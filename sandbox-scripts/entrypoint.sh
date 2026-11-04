#!/bin/sh

set -x

if [ -r $HOME/.claudebox/scripts ]; then
    for script in $HOME/.claudebox/scripts/*; do
        [ -x "$script" ] && ln -sf "$script" $HOME/bin/$(basename "$script")
    done
fi

exec "$STARTCMD" "$@"
