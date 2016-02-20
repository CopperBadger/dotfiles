#! /bin/bash
#
# I3 bar with https://github.com/LemonBoy/bar

. $(dirname $0)/i3_lemonbar_config

if [ $(pgrep -cx $(basename $0)) -gt 1 ] ; then
    printf "%s\n" "The status bar is already running." >&2
    exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

[ -e "${panel_fifo}" ] && rm "${panel_fifo}"
mkfifo "${panel_fifo}"

# echo "=== Starting up bar at $(date +%c)" >> bar.log

### EVENTS METERS

# Window title, "WIN"
xprop -spy -root _NET_ACTIVE_WINDOW | sed -un 's/.*\(0x.*\)/WIN\1/p' > "${panel_fifo}" &

# i3 Workspaces, "WSP"
$(dirname $0)/i3_workspaces.py > ${panel_fifo} &

# IRC, "IRC"
# only for init
# ~/bin/irc_warn &

# Conky, "SYS"
conky -c $(dirname $0)/i3_lemonbar_conky > "${panel_fifo}" &

### UPDATE INTERVAL METERS
cnt_vol=${upd_vol}
cnt_mail=${upd_mail}
cnt_mpd=${upd_mpd}
cnt_bat=${upd_bat}
cnt_ssid=${upd_ssid}

while :; do

  # Volume, "VOL"
  if [ $((cnt_vol++)) -ge ${upd_vol} ]; then
    echo "VOL$(alsa-status)" > "${panel_fifo}" &
    cnt_vol=0
  fi

  # MPD
  if [ $((cnt_mpd++)) -ge ${upd_mpd} ]; then
    printf "%s%s\n" "MPD" "$(mpc current -f '[[%artist% - ]%title%]|[%file%]' 2>&1 | head -c 70)" > "${panel_fifo}"
    cnt_mpd=0
  fi

  # Battey, "BAT"
  if [ $((cnt_bat++)) -ge ${upd_bat} ]; then
    echo "$(batstat)" > "${panel_fifo}" &
    cnt_bat=0
  fi

  # SSID, "SID"
  if [ $((cnt_ssid++)) -ge ${upd_ssid} ]; then
    echo "SID$(iwgetid -r)" > "${panel_fifo}" &
    cnt_ssid=0
  fi

  # Finally, wait 1 second
  sleep 1s;

done &

#### LOOP FIFO

cat "${panel_fifo}" | $(dirname $0)/i3_lemonbar_parser.sh \
  | lemonbar -p -f "${font}" -f "${iconfont}" -g "${geometry}" -B "${color_back}" -F "${color_fore}" -u 3 &

wait

