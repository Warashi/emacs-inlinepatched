#!/bin/sh
script_dir="$(cd "$(dirname "$(readlink "${BASH_SOURCE:-$0}")")"; pwd)"
exec "$script_dir/Emacs" "$@"
