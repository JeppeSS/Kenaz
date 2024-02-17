package kenaz

none_event ::  #force_inline proc "contextless" () -> Event {
    return Event{ type = .None }
}

quit_window_event :: #force_inline proc "contextless" () -> Event {
    return Event { type = .Window_Event, data = Window_Event{ type = .Quit } }
}

maximize_window_event :: #force_inline proc "contextless" () -> Event {
    return Event { type = .Window_Event, data = Window_Event{ type = .Maximize } }
}

minimize_window_event :: #force_inline proc "contextless" () -> Event {
    return Event { type = .Window_Event, data = Window_Event{ type = .Minimize } }
}

restore_window_event :: #force_inline proc "contextless" () -> Event {
    return Event { type = .Window_Event, data = Window_Event{ type = .Restore } }
}

resize_window_event :: #force_inline proc "contextless" (size: Size) -> Event {
    return Event { type = .Window_Event, data = Window_Event{ type = .Resize, data = size } }
}


move_window_event :: #force_inline proc "contextless" (position: Position) -> Event {
    return Event { type = .Window_Event, data = Window_Event{ type = .Move, data = position } }
}