#!/bin/sh
echo -ne '\033c\033]0;derelict idyll\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/derelict idyl.x86_64" "$@"
