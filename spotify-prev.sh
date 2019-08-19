#!/usr/bin/env bash
# Dependencies: bash>=3.2, coreutils, file, spotify, procps-ng, wmctrl, xdotool

# Makes the script more portable
readonly DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

readonly ICON="${DIR}/icons/prev.svg"

if pidof spotify &> /dev/null; then
  # Panel
  INFO="<img>${ICON}</img>"
  INFO+="<click>dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous</click>"

  # Tooltip
  MORE_INFO="<tool>"
  MORE_INFO+="Previous Track"
  MORE_INFO+="</tool>"
else
    INFO="<txt>"
    INFO+=""
    INFO+="</txt>"
fi

# Panel Print
echo -e "${INFO}"

# Tooltip Print
echo -e "${MORE_INFO}"
