#!/usr/bin/env nu

def main [] {
    let active_workspace = (
        hyprctl -j activeworkspace
            | from json
            | append []
            | to json
    );

    let all_workspaces = (
        hyprctl -j workspaces
            | from json
            | sort-by id
            | uniq-by id
            | to json
    );

    let current_workspaces = {
        active: $active_workspace,
        all: $all_workspaces
    };

    $current_workspaces;
}
