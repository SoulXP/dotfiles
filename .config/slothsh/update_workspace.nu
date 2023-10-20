#!/usr/bin/env nu

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

    ({ active: $active_workspace, all: $result_workspaces } | to json -r)
}

def main [] {
    let cache_path = $"($env.HOME)/.cache/workspaces"
    let current_workspaces = $"(check_workspaces)\n"

    if ($cache_path | path exists) {
        let total_cache_lines = (open $cache_path | lines | length)
        if $total_cache_lines > 200 {
            rm -f $cache_path
        }
    }

    $current_workspaces | save --append /home/slothsh/.cache/workspaces
}
