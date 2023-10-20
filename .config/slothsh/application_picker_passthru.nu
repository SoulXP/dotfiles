#!/usr/bin/env nu

def main [] {
    mut count = 0;
    while (ps | where name == "rofi" | is-empty) and $count < 100 {
        sleep 100ms;
        $count += 1;
    }

    ydotool key 125:1 125:0;
}
