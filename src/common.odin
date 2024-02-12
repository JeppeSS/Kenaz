package kenaz

Window_Error :: union #shared_nil {
    General_Error,
    Create_Window_Error,
    Poll_Event_Error
}


General_Error :: enum u32 {
    None                = 0,
}

// TODO[Jeppe]: Consider naming
Event :: struct {
    type: Event_Type,
    data: union {
        Window_Event
    }
}

Event_Type :: enum u8 {
    None         = 0,
    Window_Event = 1,
    Input_Event  = 2
}

Window_Event :: struct {
    type: Window_Event_Type,
    data: union {
        Size
    }
}


Window_Event_Type :: enum u8 {
    Quit      = 0,
    Resize    = 1,
    Maximize  = 2,
    Minimize  = 3,
    Restore   = 4
}

Position :: struct {
    x: u32,
    y: u32
}

Size :: struct {
    width:  u32,
    height: u32
}

Window_Mode :: enum u8 {
    Windowed   = 0,
    Fullscreen = 1,
    Borderless = 2
}

Window :: struct {
    title:          string,
    position:       Position,
    size:           Size,
    mode:           Window_Mode,
    minimized:      bool,
    queue:          [dynamic]Event, // TODO[Jeppe]: Is queue overkill? Would a single event be sufficient?
    using specific: Window_Os_Specific
}


is_size_equal :: #force_inline proc "contextless" (s1: Size, s2: Size) -> bool {
    return s1.height == s2.height && s1.width == s2.width
}