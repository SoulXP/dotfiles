#!/usr/bin/env nu

# Declare desktop widgets
def main [] {
    let desktop_widgets = [
        "system_bar_left_window"
        "system_bar_right_window"
    ]

    for $eww_widget in $desktop_widgets {
        eww open $eww_widget
    }
}
