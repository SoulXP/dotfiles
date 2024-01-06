#!/usr/bin/env nu

def get_application_icon_path [name: string] {
    let icon_path = (
        fd --type f "\\.(png|svg)" "/usr/share/icons/Papirus/128x128/apps"
            | split row "\n"
            | drop
            | filter { |v| $v =~ ($name | str downcase) }
    );

    if ($icon_path | length) == 0 {
        return "/usr/share/icons/Papirus-Dark/128x128/apps/utilities-terminal.svg"
    }

    $icon_path | get 0
}

def get_open_applications [] {
    let active_workspace = (hyprctl activeworkspace -j | from json | get id | into int)
    let open_applications = (
        hyprctl clients -j
            | str replace --all --multiline -r '"monitor": \d{4,}' '"monitor": -1'
            | from json
            | select address mapped workspace monitor initialClass
            | filter { |v| $v.mapped and $v.workspace.id == $active_workspace }
            | each { |v| { icon: (get_application_icon_path $v.initialClass) } }
    );

    $open_applications
}

def check_focus [id: int, monitors: table] {
    mut is_active = false
    for m in $monitors {
        $is_active = $is_active or $id == $m.activeWorkspace_id
    }
    $is_active
}

def check_workspaces [] {
    let active_workspace = (
        hyprctl -j activeworkspace
            | from json
            | append []
    );

    mut default_workspaces = [
        {monitor: "", focus: false, active: false, id: 1}
        {monitor: "", focus: false, active: false, id: 2}
        {monitor: "", focus: false, active: false, id: 3}
        {monitor: "", focus: false, active: false, id: 4}
        {monitor: "", focus: false, active: false, id: 5}
        {monitor: "", focus: false, active: false, id: 6}
        {monitor: "", focus: false, active: false, id: 7}
        {monitor: "", focus: false, active: false, id: 8}
        {monitor: "", focus: false, active: false, id: 9}
        {monitor: "", focus: false, active: false, id: 10}
    ]

    # let focused_workspace = (hyprctl -j activeworkspace | from json | select id | values | get 0 | into int)
    let focused_workspace = (hyprctl -j monitors | from json | select id activeWorkspace | flatten)
    let result_workspaces = (hyprctl -j workspaces
        | from json
        | select id monitor
        | each { |v| {monitor: $v.monitor, focus: (check_focus $v.id $focused_workspace) active: true, id: $v.id} }
        | append $default_workspaces
        | sort-by id
        | uniq-by id
    )

    let open_applications = get_open_applications

    ({ active: $active_workspace, all: $result_workspaces, applications: $open_applications} | to json -r)
}

def update_workspaces [] {
    let current_workspaces = $"(check_workspaces)\n"
    $current_workspaces | save --append /home/slothsh/.cache/workspaces
}

def main [workspace: int] {
    hyprctl dispatch workspace $workspace
    update_workspaces
}
