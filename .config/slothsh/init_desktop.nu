#!/usr/bin/env nu

def main [] {
    # Wallpaper Initialization
    swww init

    # Widgets Initialization
    eww daemon

    # File Browser Initialization
    thunar --daemon
}
