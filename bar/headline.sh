#!/bin/bash

background=964070
foreground=CCCCCC

font=-*-Terminus-*-*-*-*-*-*-*-*-*
font2=-*-stlarch-*-*-*-*-*-*-*-*-*
sep="|"

> ticker.log
python ~/Development/lemonticker/lemonticker.py &

while true; do
	myclock=$(date +"%d %b %Y, %I:%M %p")

	latest=$(tail -n 1 /home/copper/ticker.log )
	latestDisplay=$(echo "$latest" | cut -f 1,2 | sed -e 's/\t/ /')
	latestLink=$(echo "$latest" | cut -f 3 | sed -e 's/^http\:\/\///')

	echo "%{B#FF$background}%{F#FF$foreground} %{B#FF$background} $myclock $sep %{A:chromium \"$latestLink\":} $latestDisplay %{A}"

	sleep 15
done |

lemonbar -g 1000x28+366+0 -d -f $font,$font2 -B \#FF$background -F \#FF$foreground | bash
