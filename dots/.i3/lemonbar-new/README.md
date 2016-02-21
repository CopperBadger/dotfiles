![At the end of our lives, it's good to be the only thing left](http://i.imgur.com/ZSo85b2.png)

## Installation + Usage

Dependencies are:

* [lemonbar-xft](https://aur.archlinux.org/packages/lemonbar-xft-git/)
* Python3
* The [i3ipc library](https://pypi.python.org/pypi/i3ipc) via pip (it's also available [via the AUR](https://aur.archlinux.org/packages/i3ipc-python-git/)).
* [Conky](https://aur.archlinux.org/packages/conky-git/)
* [Font Awesome](https://aur.archlinux.org/packages/otf-font-awesome/) (I recommend [`xfd`](https://www.archlinux.org/packages/extra/x86_64/xorg-xfd/) for browsing icons)
* [Noto Sans](https://aur.archlinux.org/packages/ttf-noto/) is the default font, feel free to switch it out in `i3_lemonbar_config`
* If you want the same workspace icons + names I use, please consult / copy from [my i3 config](https://github.com/CopperBadger/dotfiles/blob/master/dots/.i3/config-new).

To run the lemonbar, simply run the included `i3_lemonbar.sh` script.

Because `i3ipc` likes to crash sometimes, the bar might freeze from time to time
(this seems to happen disproportionately on X startup). If this happens, simply run
the included `lb-restart` script. On much more rare occaisions, all of i3
will freeze. I am not sure if this is related to the bar or not, but in case it is,
I'll note here that the best way to fix this is to open a separate TTY terminal on
your machine (`Ctrl+Alt+F2`, for example), log in, and kill the `i3` process.

## Disclaimer

This Lemonbar setup is by GitHub user **electro7**. I've made several personal
changes to get my system and theme, but you should check out his original repo
if you're interested in using for your own system. It is located here:

https://github.com/electro7/dotfiles/tree/master/.i3/lemonbar
