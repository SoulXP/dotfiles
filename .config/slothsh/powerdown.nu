#!/usr/bin/env nu

def main [type: int] {
    match $type {
        1 => {
            # TODO: graceful shutdown
            systemctl poweroff
        }

        2 => {
            # TODO: graceful shutdown
            systemctl reboot
        }

        -1 => {
            dunstify "[DEV] System" "Powering off..."
        }

        -2 => {
            dunstify "[DEV] System" "Restarting..."
        }

        _ => { print "error: powerdown option not recognized" }
    }
}
