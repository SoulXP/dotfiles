#!/usr/bin/env nu

def main [] {
    mut default_workspaces = [
        {focus: false, active: false, id: 1}
        {focus: false, active: false, id: 2}
        {focus: false, active: false, id: 3}
        {focus: false, active: false, id: 4}
        {focus: false, active: false, id: 5}
        {focus: false, active: false, id: 6}
        {focus: false, active: false, id: 7}
        {focus: false, active: false, id: 8}
        {focus: false, active: false, id: 9}
        {focus: false, active: false, id: 10}
    ]

    let focused_workspace = (hyprctl -j activeworkspace | from json | select id | values | get 0 | into int)

    let result_workspaces = (hyprctl -j workspaces
        | from json
        | select id
        | each { |v| {focus: ($focused_workspace == $v.id) active: true, id: $v.id} }
        | append $default_workspaces
        | sort-by id
        | uniq-by id
    )

    echo ($result_workspaces | to json -r)
}
