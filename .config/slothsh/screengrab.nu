#!/usr/bin/env nu

def main [type: int] {
    # TODO: default location for screenshots
    let dir = $"/home/slothsh/.config/rofi/launchers/type-4"
    let default_name = "screenshot"
    let format = "jpg"
    let timestamp = (date now | format date "%d%m%y%H%M%S")
    let output_file = $"($default_name)_($timestamp).($format)"
    let message = "<b>Select type of screenshot to capture...</b>"

    if $type == 0 {
        hyprshot -m region -o $env.SLSH_SCREENSHOTS_FOLDER -f $output_file
    } else {
        "Output\nRegion\nWindow" | rofi -dmenu -theme $"($dir)/style-1.rasi" -mesg $message | str downcase | xargs -I{} hyprshot -m {} -o $env.SLSH_SCREENSHOTS_FOLDER -f $output_file
    }
}
