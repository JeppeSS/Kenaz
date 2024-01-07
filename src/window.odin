package kenaz


create :: proc(p_create_info: ^Window_Create_Info, p_window: ^Window) -> Window_Error {
    if p_create_info != nil {
        p_window.title    = p_create_info.title != nil ? string(p_create_info.title) : string("Kenaz")
        p_window.position = p_create_info.position
        p_window.size     = p_create_info.size
        return nil
    }
    return .Invalid_Create_Info
}