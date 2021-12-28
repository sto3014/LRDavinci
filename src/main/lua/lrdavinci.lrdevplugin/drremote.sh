#!/usr/bin/env bash
export RESOLVE_SCRIPT_API="/Library/Application Support/Blackmagic Design/DaVinci Resolve/Developer/Scripting"
export RESOLVE_SCRIPT_LIB="/Applications/DaVinci Resolve/DaVinci Resolve.app/Contents/Libraries/Fusion/fusionscript.so"
export PYTHONPATH="$PYTHONPATH:$RESOLVE_SCRIPT_API/Modules"
if [ "$2" = "settimeline" ]; then
   open "/Applications/DaVinci Resolve/DaVinci Resolve.app"
fi
$HOME/.pyenv/versions/3.6.15/bin/drremote $* -w 15 2>/tmp/err.log