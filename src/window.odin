package kenaz

import "core:log"

create :: proc(title := "Kenaz", position := Position{ 0, 0 }, size := Size{ 800, 640 }, mode: Window_Mode = .Windowed) -> (^Window, Window_Error) {
    p_window          := new(Window)
    p_window.title    = title
    p_window.position = position
    p_window.size     = size
    p_window.mode     = mode
    p_window.is_open  = true

    // Initialize OS specific stuff
    error := _initialize(p_window)

    log.info("> Creating window...")
    log.infof("  => Title: %s", p_window.title)
    log.infof("  => Mode: %v", p_window.mode)
    log.infof("  => Size:  (%d, %d)", p_window.size.width, p_window.size.height)
    log.infof("  => Position: (%d, %d)", p_window.position.x, p_window.position.y)

    return p_window, error
}


poll_event :: proc(p_window: ^Window, p_event: ^Event) -> (pending_event: bool) {
    p_event.type = .None
    p_event.data = nil
    return _poll_event(p_window, p_event)
}