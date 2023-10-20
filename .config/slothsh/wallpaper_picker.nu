#!/usr/bin/env nu

def get_random_type [] {
    let transition_options = [
        "fade"
        "left"
        "right"
        "top"
        "bottom"
        "wipe"
        "wave"
        "grow"
        "center"
        "outer"
    ]

    let end_range = ($transition_options | length) - 1
    ($transition_options | get (random integer 0..$end_range))
}

def main [] {
    let wallpapers = (fd -a . $env.SLSH_WALLPAPERS_FOLDER)
    let dir = $"/home/slothsh/.config/rofi/launchers/type-4"

    let position_x = (random integer 0..1920)
    let position_y = (random integer 0..1080)
    let message = "<b>Select an image to set as new wallpaper...</b>"

    let options_table = (fd . $env.SLSH_WALLPAPERS_FOLDER
        | str trim
        | split row "\n"
        | path basename
        | split column ".")

    $options_table
        | select "column1"
        | values
        | get 0
        | sort -r
        | reduce { |v, acc| $"($v)\n" + $acc }
        | rofi -dmenu -theme $"($dir)/style-1.rasi" -format "[i] s" -mesg $message
        | str substring 1..
        | split row "] "
        | each { |v| $v | str trim }
        | do { || let index = ($in.0 | into int); $in.1 + "." + ($options_table | get $index | select column2 | values | get 0) }
        | append ["/", $env.SLSH_WALLPAPERS_FOLDER]
        | reverse
        | str join
        | xargs -I{} swww img --transition-duration 2 --transition-type grow --transition-pos $"($position_x),($position_y)" --transition-fps 60 {}
}
