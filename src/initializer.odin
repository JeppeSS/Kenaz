package kenaz

none_event ::  #force_inline proc "contextless" () -> Event {
    return Event{ type = .None }
}

quit_window_event :: #force_inline proc "contextless" () -> Event {
    return Event { type = .Window_Event, data = Window_Event{ type = .Quit } }
}

resize_window_event :: #force_inline proc "contextless" (size: Size) -> Event {
    return Event { type = .Window_Event, data = Window_Event{ type = .Resize, data = size } }
}

