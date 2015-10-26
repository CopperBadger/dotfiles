#!/bin/bash

STAT=$(/usr/bin/pulseaudio-ctl full-status)
VOL=$(echo "$STAT" | cut -d ' ' -f 1)
MUTE=$(echo "$STAT" | cut -d ' ' -f 2)

[[ $MUTE == "yes" ]] && MUTE=M || MUTE=+
echo "$MUTE $VOL"
