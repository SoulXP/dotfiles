#!/usr/bin/env nu

def main [] {
    source-env "./environment.nu"

    curl -sf $"https://api.openweathermap.org/data/2.5/weather?appid=($env.WEATHER_API_KEY)&units=($env.WEATHER_UNITS)&id=($env.WEATHER_LOCATION)"
        | from json
        | select main.temp
        | values
        | math round
        | save -f $env.WEATHER_CACHE

    # (random decimal) * 32 | math round | save -f $env.WEATHER_CACHE
}
