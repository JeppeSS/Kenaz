//+build windows
//+private
package kenaz

import win "core:sys/windows"

Window_Os_Specific :: struct {
    h_instance: win.HINSTANCE,
}


_create :: proc(p_window: ^Window) -> Window_Error {
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
        lpszClassName = win.utf8_to_wstring("WindowClass")
    }

    if win.RegisterClassW(&window_class) == 0 {
        return Create_Window_Error(win.GetLastError())
    }

    p_window.h_instance = h_instance

    return nil
}


window_callback :: proc "stdcall" (window: win.HWND, message: win.UINT, wParam: win.WPARAM, lParam: win.LPARAM) -> win.LRESULT {
    return win.DefWindowProcW(window, message, wParam, lParam)
}