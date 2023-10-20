#!/usr/bin/env nu

def main [format: string] {
    date now | format date $format
}
