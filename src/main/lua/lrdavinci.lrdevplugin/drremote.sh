#!/usr/bin/env bash
# The RESLOVE_SCRIPT* variables depend on the Davinci Resolve installation, as well as the open command.
# The path /usr/local/bin/drremote must be adopted if you use multiple Python versions
# You may in- or decrease the waiting time "-w 15"
# Please do not change 2>/tmp/drremote.err. It is needed by the plug-in.
export RESOLVE_SCRIPT_API="/Library/Application Support/Blackmagic Design/DaVinci Resolve/Developer/Scripting"
export RESOLVE_SCRIPT_LIB="/Applications/DaVinci Resolve/DaVinci Resolve.app/Contents/Libraries/Fusion/fusionscript.so"
export PYTHONPATH="$PYTHONPATH:$RESOLVE_SCRIPT_API/Modules"
# settimeline
if [ "$2" = "settimeline" ]; then
   open "/Applications/DaVinci Resolve/DaVinci Resolve.app"
   /usr/local/bin/drremote $* -w 15 2>/tmp/drremote.err
fi
# gettimeline
if [ "$2" = "gettimeline" ]; then
  /usr/local/bin/drremote $* 2>/tmp/drremote.err
fi
#
if [ -f /tmp/drremote.err ]; then
  chmod 666 /tmp/drremote.err
fi
