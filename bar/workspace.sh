#!/bin/bash

bkga=eeeeee
bkgi=d9e9e5
foreground=936171
font=-*-terminus-*-*-*-*-*-*-*-*-*
icons=-*-stlarch-*-*-*-*-*-*-*-*-*

xtitle -s | \
while read window; do
	workspace="$(wmctrl -d | grep "*" | cut -c 1)"

	case "$workspace" in
		0) 
			echo "%{A:wmctrl -s 0:}%{B#FF$bkga}   term   %{A}%{A:wmctrl -s 1:}%{B#FF$bkgi}   www   %{A}%{A:wmctrl -s 2:}%{B#FF$bkgi}   src   %{A}%{A:wmctrl -s 3:}%{B#FF$bkgi}   app   %{A}%{A:wmctrl -s 4:}%{B#FF$bkgi}   xtra   %{A}"
			;;
		1) 
			echo "%{A:wmctrl -s 0:}%{B#FF$bkgi}   term   %{A}%{A:wmctrl -s 1:}%{B#FF$bkga}   www   %{A}%{A:wmctrl -s 2:}%{B#FF$bkgi}   src   %{A}%{A:wmctrl -s 3:}%{B#FF$bkgi}   app   %{A}%{A:wmctrl -s 4:}%{B#FF$bkgi}   xtra   %{A}"
			;;
		2) 
			echo "%{A:wmctrl -s 0:}%{B#FF$bkgi}   term   %{A}%{A:wmctrl -s 1:}%{B#FF$bkgi}   www   %{A}%{A:wmctrl -s 2:}%{B#FF$bkga}   src   %{A}%{A:wmctrl -s 3:}%{B#FF$bkgi}   app   %{A}%{A:wmctrl -s 4:}%{B#FF$bkgi}   xtra   %{A}"
			;;
		3) 
			echo "%{A:wmctrl -s 0:}%{B#FF$bkgi}   term   %{A}%{A:wmctrl -s 1:}%{B#FF$bkgi}   www   %{A}%{A:wmctrl -s 2:}%{B#FF$bkgi}   src   %{A}%{A:wmctrl -s 3:}%{B#FF$bkga}   app   %{A}%{A:wmctrl -s 4:}%{B#FF$bkgi}   xtra   %{A}"
			;;
		4) 
			echo "%{A:wmctrl -s 0:}%{B#FF$bkgi}   term   %{A}%{A:wmctrl -s 1:}%{B#FF$bkgi}   www   %{A}%{A:wmctrl -s 2:}%{B#FF$bkgi}   src   %{A}%{A:wmctrl -s 3:}%{B#FF$bkgi}   app   %{A}%{A:wmctrl -s 4:}%{B#FF$bkga}   xtra   %{A}"
			;;
	esac
done |

lemonbar -g 282x28+0+0 -d -f $font -B \#FF$bkgi -F \#FF$foreground | bash
