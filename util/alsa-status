#!/bin/bash

if [[ ! -z "$1" ]]; then
  snd_line=`amixer get Master | grep $1`
else
  snd_line=`amixer get Master | grep ': Playback' | tail -n 1`
fi

[[ ! -z `echo $snd_line | grep -o "\[off\]"` ]] && snd_sym=M || snd_sym=+

echo $snd_line | sed -un 's/.*\[\([0-9]*\)%\].*/\1/p' | (read lvl; echo "$snd_sym $lvl")
