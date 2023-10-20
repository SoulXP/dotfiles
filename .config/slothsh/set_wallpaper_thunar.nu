#!/usr/bin/env nu

def main [wallpaper_path: string] {
    let position_x = (random integer 0..1920)
    let position_y = (random integer 0..1080)
    swww img --transition-duration 2 --transition-type grow --transition-pos $"($position_x),($position_y)" --transition-fps 60 $wallpaper_path
}
