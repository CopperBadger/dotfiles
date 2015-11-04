# exec startxfce4
# 
# sxhkd %
# exec bspwm
#
compton --config "$HOME/.config/compton/compton.conf" &
xrdb -load "$HOME/.Xresources"
xset +fp "$HOME/.fonts"
xset fp rehash
update-wallpaper
pulseaudio --start
exec i3
