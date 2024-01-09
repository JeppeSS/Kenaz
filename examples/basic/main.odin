package main

import "core:fmt"
import "core:log"

import knz "../../src"

Default_Console_Logger_Opts ::
	log.Options{.Level, .Terminal_Color} |
	log.Full_Timestamp_Opts


main :: proc(){
    context.logger = log.create_console_logger(opt = Default_Console_Logger_Opts)


    info := knz.Window_Create_Info {
        title = "test",
        position = knz.Position{ 0, 0},
        size     = knz.Size{ 860, 640 }
    }


    window: knz.Window
    result := knz.create(&info, &window)
    if result != nil {
        log.error(result)
        return
    }

    fmt.printf("%s", window.title)

}