package kenaz

import "core:log"

create :: proc(p_create_info: ^Window_Create_Info, p_window: ^Window) -> Window_Error {
    if p_create_info != nil {
        p_window.title    = p_create_info.title != nil ? string(p_create_info.title) : string("Kenaz")
        p_window.position = p_create_info.position
        p_window.size     = p_create_info.size
        p_window.mode     = p_create_info.mode != nil ? p_create_info.mode : .Windowed
 
        log.info("> Creating window...")
        log.infof("  => Title: %s", p_window.title)
        log.infof("  => Mode: %v", p_window.mode)
        log.infof("  => Size:  (%d, %d)", p_window.size.width, p_window.size.height)
        log.infof("  => Position: (%d, %d)", p_window.position.x, p_window.position.y)
        
        return _create(p_window)
    }
    return .Invalid_Create_Info
}