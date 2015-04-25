#!/bin/bash

background=3e1a2f
foreground=CCCCCC

font=-*-terminus-*-*-*-*-*-*-*-*-*
font2=-*-stlarch-*-*-*-*-*-*-*-*-*

while true; do
	batphase=$(battery | cut -d " " -f 1)
	batint=$(battery | cut -d " " -f 2 )
	batbkg="$background"
	batcol="$foreground"
	baticon=""
	if [ "$batphase" = "Charging" ]; then
		baticon="\ue040"
		batcol="3e1a2f"
		batbkg="fcbf2a"
	elif [ "$batint" -lt 15 ]; then 
		batcol="FFFFFF"
		batbkg="ffd264"
		baticon="\ue030"
	elif [ "$batint" -gt 70 ]; then
		baticon="\ue033"
	elif [ "$batint" -gt 40 ]; then
		baticon="\ue032"
	else
		baticon="\ue031"
	fi

	echo "%{B#FF$batbkg}%{F#FF$batcol}  $(printf '%b' "$baticon") $(batpct)%%  "

	sleep 30
done |

lemonbar -g 84x28+282+0 -d -f $font,$font2 -B \#FF$background -F \#FF$foreground
