package main

import "core:fmt"
import knz "../../src"

main :: proc(){
    info := knz.Window_Create_Info {
        title = "test",
        position = knz.Position{ 0, 0},
        size     = knz.Size{ 860, 640 }
    }


    window: knz.Window
    knz.create(&info, &window)

    fmt.printf("%s", window.title)

}