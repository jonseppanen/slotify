#!/usr/bin/env bash
# Dependencies: bash>=3.2, coreutils, file, spotify, wmctrl, xdotool

# Makes the script more portable
readonly DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Initialize art cache
mkdir -p ${DIR}/artcache
readonly CACHEDIR=${DIR}/artcache

# Icon setup
readonly ICON="${DIR}/icons/spotify.svg"
readonly PLAYICON="${DIR}/icons/play.svg"
readonly PAUSEICON="${DIR}/icons/pause.svg"

if pidof spotify &> /dev/null; then
  # Spotify song's info
  readonly ARTIST=$(bash "${DIR}/spotify.sh" artist)
  readonly TITLE=$(bash "${DIR}/spotify.sh" title)
  readonly ALBUM=$(bash "${DIR}/spotify.sh" album)
  readonly ALBUMARTURL=$(bash "${DIR}/spotify.sh" arturl)
  readonly WINDOW_ID=$(wmctrl -l | grep "${ARTIST} - ${TITLE}" | awk '{print $1}')
  readonly ARTIST_TITLE=$(echo "${ARTIST} - ${TITLE}")
  readonly STATUS=$(bash "${DIR}/spotify.sh" status)
  readonly ALBUMUUID=$(basename ${ALBUMARTURL})
  readonly ALBUMPNG=$(echo ${CACHEDIR}/${ALBUMUUID}.png)

  # Cache album art from spotify
  if [ ! -f "${CACHEDIR}/${ALBUMUUID}.png" ]; then
    touch ${CACHEDIR}/${ALBUMUUID}.png
    wget -O ${CACHEDIR}/${ALBUMUUID} ${ALBUMARTURL}
    mogrify -format png -resize 40x40 ${CACHEDIR}/${ALBUMUUID}
    rm ${CACHEDIR}/${ALBUMUUID}
  fi

  # Panel
  if [[ ${STATUS} == "Playing" ]]; then
    INFO="<img>${ALBUMPNG}</img>"
  else
    INFO="<img>${PLAYICON}</img>"
  fi
  INFO+="<click>dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause</click>"

  # Tooltip
  MORE_INFO="<tool>"
  MORE_INFO+="<span size='1000'>\n</span>"
  MORE_INFO+="        <span fgcolor='#999' size='8000'>${STATUS}</span>        "
  MORE_INFO+="\n"
  MORE_INFO+="\n"
  MORE_INFO+="        <span size='25000' fgcolor='#FFF'>${TITLE}</span>         "
  MORE_INFO+="\n"
  MORE_INFO+="        <span size='15000' weight='Bold' fgcolor='#aaa'>${ALBUM}</span>         "
  MORE_INFO+="\n"
  MORE_INFO+="\n"
  MORE_INFO+="        <span fgcolor='#888'>By ${ARTIST}</span>         "
  MORE_INFO+="\n"
  MORE_INFO+="</tool>"
else
  # Panel
  INFO="<img>${ICON}</img>"
  INFO+="<click>spotify</click>"

  # Tooltip
  MORE_INFO="<tool>"
  MORE_INFO+="Open Spotify"
  MORE_INFO+="</tool>"
fi

# Panel Print
echo -e "${INFO}"

# Tooltip Print
echo -e "${MORE_INFO}"
