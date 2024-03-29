package kenaz

import "core:log"

create :: proc(title := "Kenaz", position := Position{ 0, 0 }, size := Size{ 800, 640 }, mode: Window_Mode = .Windowed) -> (^Window, Window_Error) {
    p_window           := new(Window)
    p_window.title     = title
    p_window.position  = position
    p_window.size      = size
    p_window.mode      = mode
    p_window.minimized = false

    error := _initialize_os_specific(p_window)

    log.info("> Creating window...")
    log.infof("  => Title: %s", p_window.title)
    log.infof("  => Mode: %v", p_window.mode)
    log.infof("  => Size:  (%d, %d)", p_window.size.width, p_window.size.height)
    log.infof("  => Position: (%d, %d)", p_window.position.x, p_window.position.y)

    return p_window, error
}


poll_event :: proc(p_window: ^Window) -> Event {
    return _poll_event(p_window)
}


destroy :: proc(p_window: ^Window) {
    delete(p_window.queue)
    free(p_window)
}