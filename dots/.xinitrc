# exec startxfce4
# 
# sxhkd %
# exec bspwm
#
compton --config "$HOME/.config/compton/compton.conf" &
xrdb -load "$HOME/.Xresources"
update-wallpaper
pulseaudio --start
exec i3
