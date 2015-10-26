# exec startxfce4
# 
# sxhkd %
# exec bspwm
#
compton --config "$HOME/.config/compton/compton.conf" &
update-wallpaper
pulseaudio --start
exec i3
