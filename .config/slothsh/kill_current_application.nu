#!/usr/bin/env nu

def main [] {
    let current_window_data = (hyprctl -j activewindow | from json)
    if ($current_window_data | columns | length) > 1 {
        let current_pid = (
            hyprctl -j activewindow
            | from json
            | select pid
            | values
            | to text
            | into int
        )
        kill -s 3 $current_pid
    } 
}
