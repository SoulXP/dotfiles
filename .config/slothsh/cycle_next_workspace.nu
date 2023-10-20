#!/usr/bin/env nu

def main [cycle_value: int] {
    hyprctl dispatch workspace $"e($cycle_value | to text)"
}
