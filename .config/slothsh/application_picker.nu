#!/usr/bin/env nu

def make_description [v, padding] {
    if ($v.title | str downcase) != ($v.description | str downcase) {
        let description = ("" | fill -a right -c " " -w $padding) + "-> " + $v.description;
        let new_v = $v | merge {description: $description} 
        return $new_v;
    }

    let new_v = $v | merge {description: ""};
    return $new_v;
}

def main [] {
    hyprctl keyword unbind SUPER,TAB

    let dir = $"/home/slothsh/.config/rofi/switchers/type-1"
    let message = "<b>Select an application...</b>"
    let release_key = "![133]"
    let cycle_next_key = "Tab,Super+Tab"
    let cycle_prev_key = "ISO_Left_Tab,Super+ISO_Left_Tab"

    try {
        let active_client = (
            hyprctl activewindow -j
                | from json
                | select address initialTitle workspace monitor title
                | enumerate
                | each { |v| { address: $v.item.address, title: ($v.item.initialTitle | str trim), workspace: $v.item.workspace.name, monitor: $v.item.monitor, order: $v.index, description: $v.item.title } }
        )

        let other_clients = (
            hyprctl clients -j
                | from json
                | filter { |v| $v.workspace.id > 0 and $v.address != $active_client.0.address }
                | select address initialTitle workspace monitor title
                | enumerate
                | each { |v| { address: $v.item.address, title: ($v.item.initialTitle | str trim), workspace: $v.item.workspace.name, monitor: $v.item.monitor, order: $v.index, description: $v.item.title} }
                | sort-by workspace
        )

        let padding_largest = (
            $active_client
                | append $other_clients
                | each { |v| $v.title | str length }
                | sort --reverse
                | get 0
        ) + 1

        let application_table = (
            $active_client
                | append $other_clients
                | each { |v| make_description $v ($padding_largest - ($v.title | str length)) }
        )

        let focus_result = $application_table
            | each { |v| $v | format $"<b>{workspace}</b>: {title}{description}" }
            | str join "\n"
            | rofi -dmenu -markup-rows -theme $"($dir)/style-1.rasi" -format "[i] s" -mesg $message -kb-accept-entry $release_key -kb-element-next $cycle_next_key -kb-element-prev $cycle_prev_key -selected-row 1
            | str substring 1..
            | split row "] "
            | each { |v| $v | str trim }
            | do { || let index = ($in.0 | into int); ($application_table | get $index | select address | values | get 0) }

        hyprctl $"dispatch focuswindow address:($focus_result)"
        hyprctl dispatch bringactivetotop
    } catch {
        let focus_result = "Home"
            | rofi -dmenu -markup-rows -theme $"($dir)/style-1.rasi" -format "[i] s" -mesg $message -kb-accept-entry $release_key -kb-element-next $cycle_next_key -kb-element-prev $cycle_prev_key -selected-row 1
    }

    hyprctl keyword bind SUPER,TAB,exec,rofi-application-picker-slothsh
    hyprctl keyword bind SUPER,TAB,exec,/home/slothsh/.config/slothsh/application_picker_passthru.nu
    hyprctl keyword bind SUPER,TAB,exec,hyprctl keyword unbind SUPER,TAB
}
