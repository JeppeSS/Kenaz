package main

import "core:log"

import knz "../../src"


main :: proc(){
    context.logger = log.create_console_logger()

    p_window, window_error := knz.create()
    if window_error != nil {
        log.errorf("Failed to create window: %d", window_error)
        return
    }

    game_loop: for {
        for event := knz.poll_event(p_window); event.type != .None; event = knz.poll_event(p_window) {
            if event.type == .Window_Event {
                window_event := event.data.(knz.Window_Event)
                if window_event.type == .Quit {
                    break game_loop
                } else if window_event.type == .Resize {
                    log.info(window_event.data)
                }
            }
        }
    }

}