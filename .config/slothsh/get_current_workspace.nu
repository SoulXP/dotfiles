#!/usr/bin/env nu

def main [] {
    hyprctl -j activeworkspace
    | from json
    | get id
}
