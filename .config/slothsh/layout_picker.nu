#!/usr/bin/env nu

def main [] {
    let dir = $"/home/slothsh/.config/rofi/launchers/type-4"
    let message = "<b>Select a layout scheme...</b>"

    let layouts_table = [
        "Master",
        "Dwindle"
    ]

    $layouts_table
        | into string
        | str join "\n"
        | rofi -dmenu -theme $"($dir)/style-1.rasi" -format "[i] s" -mesg $message
        | str substring 1..
        | split row "] "
        | each { |v| $v | str trim }
        | get 1
        | str downcase
        | xargs -I{} hyprctl keyword general:layout {}
}
