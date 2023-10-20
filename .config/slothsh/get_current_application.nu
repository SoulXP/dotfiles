#!/usr/bin/env nu

def default_application [] {
    let active_workspace = (hyprctl -j activeworkspace | from json | get id)
    { active: "Home", id: $active_workspace } | to json
}

def main [] {
    try {
        let active_window = (
            hyprctl -j activewindow
                | from json
                | select class workspace at size
                | flatten workspace
                | each { |v| { active: ($v.class | str title-case), id: $v.id, size: $v.size, at: $v.at } }
                | get 0
        )

        # let cursor_pos = (hyprctl -j cursorpos | from json)
        # if $active_window.at.0 <= $cursor_pos.x and $cursor_pos.x <= ($active_window.at.0 + $active_window.size.0) {
        #     let rtn = ($active_window | to json);
        #     return $rtn;
        # }

        return ($active_window | to json);
    }

    default_application
}
