#!/usr/bin/env nu

def main [] {
    source-env "./environment.nu"
    if ($env.WEATHER_CACHE | path exists) { 
        cat $env.WEATHER_CACHE
    } else {
        echo "0"
    }
}
