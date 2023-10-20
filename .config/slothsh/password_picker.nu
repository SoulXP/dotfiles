#!/usr/bin/env nu

# TODO: Function to clean pass name

def main [] {
    let dir = $"/home/slothsh/.config/rofi/launchers/type-4"
    let message = "<b>Select a password to copy to your clipboard</b>"

    # TODO: Append directory names
    let password_listing = fd ".+\\.gpg" ~/.password-store/
        | split row "\n"
        | path basename
        | each { |v| ($v | split row "." | get 0) }

    $password_listing
        | str join "\n"
        | rofi -dmenu -theme $"($dir)/style-1.rasi" -format "s" -mesg $message
        | xargs -I{} pass show {} --clip
}
