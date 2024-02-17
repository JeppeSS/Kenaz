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

    defer knz.destroy(p_window)

    game_loop: for {
        for event := knz.poll_event(p_window); event.type != .None; event = knz.poll_event(p_window) {
            if event.type == .Window_Event {
                window_event := event.data.(knz.Window_Event)
                if window_event.type == .Quit {
                    log.info("Quit!")
                    break game_loop
                } else if window_event.type == .Resize {
                    log.info(window_event.data.(knz.Size))
                } else if window_event.type == .Maximize {
                    log.info("Maximize!")
                } else if window_event.type == .Minimize {
                    log.info("Minimize!")
                } else if window_event.type == .Restore {
                    log.info("Restore!")
                } else if window_event.type == .Move {
                    log.info(window_event.data.(knz.Position))
                }
            }
        }
    }

}