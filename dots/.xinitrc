# exec startxfce4
# 
# sxhkd %
# exec bspwm
#
compton --config "$HOME/.config/compton/compton.conf" &
"$HOME/.fehbg"
pulseaudio --start
exec i3
