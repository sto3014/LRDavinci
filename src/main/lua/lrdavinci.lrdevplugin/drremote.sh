#!/usr/bin/env bash
cd
export PATH=/Users/dieterstockhausen/.pyenv/bin:$PATH
export RESOLVE_SCRIPT_API="/Library/Application Support/Blackmagic Design/DaVinci Resolve/Developer/Scripting"
export RESOLVE_SCRIPT_LIB="/Applications/DaVinci Resolve/DaVinci Resolve.app/Contents/Libraries/Fusion/fusionscript.so"
export PYTHONPATH="$PYTHONPATH:$RESOLVE_SCRIPT_API/Modules"
if [ "$2" = "settimeline" ]; then
   open "/Applications/DaVinci Resolve/DaVinci Resolve.app"
fi
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
cd $TMPDIR
pyenv local 3.6.15
drremote $*
