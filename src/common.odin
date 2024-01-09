package kenaz

Window_Error :: union #shared_nil {
    General_Error,
    Create_Window_Error
}


General_Error :: enum u32 {
    None                = 0,
    Invalid_Create_Info = 1
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


Window_Create_Info :: struct {
    title:    cstring,
    position: Position,
    size:     Size,
    mode:     Window_Mode
}


Window :: struct {
    using specific: Window_Os_Specific,
    title:          string,
    position:       Position,
    size:           Size,
    mode:           Window_Mode
}