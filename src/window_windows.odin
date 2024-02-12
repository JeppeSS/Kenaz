//+build windows
//+private
package kenaz

import win "core:sys/windows"
import "core:runtime"

Window_Os_Specific :: struct {
    h_instance: win.HINSTANCE,
    handle:     win.HWND
}

WINDOW_RESIZED   :: 0
WINDOW_MINIMIZED :: 1
WINDOW_MAXIMIZED :: 2


_initialize :: proc(p_window: ^Window) -> Window_Error {
    h_instance := cast(win.HINSTANCE)win.GetModuleHandleW(nil)
    if h_instance == nil {
        return Create_Window_Error(win.GetLastError())
    }

    window_class := win.WNDCLASSW {
        style         = win.CS_HREDRAW | win.CS_VREDRAW,
        lpfnWndProc   = window_callback,
        cbClsExtra    = 0,
        cbWndExtra    = 0, // TODO[Jeppe]: Look into if this should be DLGWINDOWEXTRA in case we want to display error dialog box.
        hInstance     = h_instance,
        hIcon         = nil, // TODO[Jeppe]: Add the possibility to set this.
        hCursor       = nil,
        hbrBackground = nil,
        lpszMenuName  = nil,
        lpszClassName = win.utf8_to_wstring("WindowClass") }

    if win.RegisterClassW(&window_class) == 0 {
        return Create_Window_Error(win.GetLastError())
    }

    window_handle := win.CreateWindowExW(0, 
        window_class.lpszClassName,
        win.utf8_to_wstring(p_window.title),
        win.WS_OVERLAPPEDWINDOW | win.WS_VISIBLE,
        i32(p_window.position.x), i32(p_window.position.y),
        i32(p_window.size.width), i32(p_window.size.height),
        nil,
        nil,
        h_instance,
        nil )
    
    if window_handle == nil {
        return Create_Window_Error(win.GetLastError())
    }

    win.SetWindowLongPtrW(window_handle, win.GWLP_USERDATA, cast(win.LONG_PTR)cast(uintptr)p_window)

    win.ShowWindow(window_handle, win.SW_NORMAL)

    p_window.h_instance = h_instance

    return nil
}


_poll_event :: proc(p_window: ^Window) -> Event {
    message := win.MSG{}
    if win.PeekMessageW(&message, nil, 0, 0, win.PM_REMOVE) {
        if message.message == win.WM_QUIT {
            return quit_window_event()
        } else {
            win.TranslateMessage(&message)
            win.DispatchMessageW(&message)
        }

    }

    queue_len := len(p_window.queue)
    if queue_len != 0 {
        event := pop_front(&p_window.queue)
        return event
    }
    
    return none_event()
}


window_callback :: proc "stdcall" (window: win.HWND, message: win.UINT, wParam: win.WPARAM, lParam: win.LPARAM) -> win.LRESULT {
    context = runtime.default_context()
    p_window := cast(^Window)cast(uintptr)win.GetWindowLongPtrW(window, win.GWLP_USERDATA)
    if p_window != nil { 
        switch message {
            case win.WM_CLOSE, win.WM_DESTROY:
                append(&p_window.queue, quit_window_event())
            case win.WM_PAINT:
                win.InvalidateRect(p_window.handle, nil, false)
            case win.WM_SIZE:
                handle_size_event(p_window, wParam, lParam)             
        }
    }
    return win.DefWindowProcW(window, message, wParam, lParam)
}

handle_size_event :: proc (p_window: ^Window, wParam: win.WPARAM, lParam: win.LPARAM) {
    switch wParam {
        case WINDOW_RESIZED:
            if p_window.minimized {
                p_window.minimized = false
                append(&p_window.queue, restore_window_event())
            } else {
                new_size := get_new_size(lParam)
                p_window.size = new_size
                append(&p_window.queue, resize_window_event(new_size))
            }
        case WINDOW_MINIMIZED:
            p_window.minimized = true
            append(&p_window.queue, minimize_window_event())
        case WINDOW_MAXIMIZED:
            new_size := get_new_size(lParam)
            p_window.size = new_size
            append(&p_window.queue, maximize_window_event())
    }

    win.InvalidateRect(p_window.handle, nil, false)

}

get_new_size :: #force_inline proc "contextless" (lParam: win.LPARAM) -> Size {
    client_width  := u32(lParam & 0xffff)
    client_height := u32((lParam & 0xffff0000) >> 16)
    return Size{ client_width, client_height }
}