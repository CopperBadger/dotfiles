# Dotfiles

Welcome to my dotfiles!

![You see an i3 configuration, it fills you with determination](http://i.imgur.com/xKbsGjp.png)

This is the configuration I use for my laptop, which runs the
**[i3-gaps window manager](https://github.com/Airblader/i3)** (a fork of i3) on
**[Arch Linux](https://www.archlinux.org/)**.

This document was written to help anyone interested in trying out my i3 config.
In all honesty, **it's not a "just works" setup**. It's gross and you'll probably
get frustrated. If you do, I'm very sorry, but I assure you that everything in
the process has a purpose, and that it will all... probably... maybe work out
for you on your machine. Actually, I can't even guarantee that. But I wish I
could! I have plans to write a script that brings the whole process together,
but for now, if you encounter difficulties, think of it as a challenge! Unless
it's easy for you. In that case, you go ahead and treat yo self!

Alright, here we go.

## Dependencies

*Note: I might forget something here. Open a ticket if you believe that
something is missing*

This setup is intended for **[i3-gaps](https://github.com/Airblader/i3)** by
Airblader. I haven't tested it with regular i3-- you'll probably have to make
a few changes if you want to use that. I've only every installed it on Arch
Linux-- I can't make any guarantees about its compatibility with other distros.

* `compton` -- Compositor (GPU acceleration for X, shadows, fades, all kinds
   spiffiness)
* `conky` -- System monitor, provides network, memory, and CPU usage info to
  lemonbar.
* `feh` -- Wallpaper-setting program and minimalst image viewer
* `mpc` -- Client for `mpd`, responsible for telling lemonbar about the currently
  playing media.
* `mpd` -- Music Player Daemon. Plays beautiful music for you. I recommend
  `ncmpcpp` as a terminal client for it.
  ([Setup](https://wiki.archlinux.org/index.php/Music_Player_Daemon#Setup))
* `iwconfig` -- Wireless interface configuration tool, used only for `wifimode`
* [Powerline](http://powerline.readthedocs.org/en/master/) -- Statusline framework
  with many plugins. Needed for `vim`, `tmux`, and shell styling.
* [Powerline Fonts](https://github.com/powerline/fonts). I can't say too much
  on this. Fonts are a pain in Linux.
* [electro7's terminusicons2mono](https://github.com/electro7/dotfiles/blob/master/.fonts/misc/terminusicons2mono.bdf)
  -- Icon font I use for lemonbar. Mostly because it's the only one I can get
  to work.
* `pulseaudio` -- If you don't use / like pulseaudio, that's okay. You'll just have
  to do a little work yourself to get the volume scripts, media key bindings,
  and shell aliases to work for whatever setup you have.
* `python3` -- For `applyxres`. You probably already have it.
* `ranger` -- Terminal file browser. Used in `bkg` script to easily browse
  available wallpapers.
* `rofi` -- Super-nice launcher, better than dmenu. Needed for `myrofi`.
* `xfce4-terminal` -- Terminal emulator, the only one supported by `applyxres`
  at the moment.
* `xprop` -- X11 window info program, makes the window title section work.

## Installation

### General

1. First, install the dependencies listed in the section above.

2. `util/` contains my custom utility scripts. Place them in a directory
  contained within your `$PATH` and ensure that they are executable. I explain
  what all of these scripts do in the Usage section later on.

3. All of the contents of `dots/` should be placed in your home directory,
  except for:
  * `compton.conf`, which should be placed in `~/.config/compton` (create this
    directory if it does not already exist)
  * `terminalrc`, the xfce4-terminal configuration, which should be placed in
    `~/.config/xfce4/terminal` (create this directory if it does not already
    exist as well)
  * `ApplyXres.template`, if you use Sublime Text, which should be placed in
    `~/.config/sublime-text-3/Packages/User`. See the "Sublime Text theme"
    section for more info. Ignore if you don't want it.
  * `bkg.service` and `bkg.timer`, two systemd units that automate background
    switching. If you use systemd, place them in one of your installation's
    unit directories. If you don't use systemd, don't sweat it.

4. Special step for Powerline. Locate your Powerline installation (it will be
  located in the `site-packages` directory of your Python installation, either
  in `~/.local` for user-only installs, or in `/lib` for global installs). Go
  into the `config_files` directory. Make a copy of `colors.json` and call it
  `colors.json.default`. Then, change the ownership of `colors.json` to
  yourself (or whatever you have to do so that you have write privileges on it).
  Also, make a symlink in your home directory to the `config_files` directory,
  and call it `pl-conf`. (ie, `ln -s /path/to/powerline/config_files/ ~/pl-conf`)

### Wallpapers

Run the `wallpaper.init` script to set up your `~/.wallpapers` directory. You
will need to supply the path for a default background image. To cancel, press
Ctrl+c.

My setup has three modes for wallpaper display:

1. "Normal" -- One wallpaper is displayed all of the time.
2. `DAY` -- A series of wallpapers cycle through the day, according to the
    output of the `timeofday` utility script.
3. `RANDOM` -- (Not yet implemented) Will select a random image from a specified
    directory at regular intervals.

The latter two require a scheduled job to trigger the `update-wallpaper` script
(described below). If you use systemd, you may simply review and install the
included `bkg.service` and `bkg.timer` units. If you do not use systemd, you
will have to schedule the job yourself.

One of these three modes should be the sole contents of the `~/.wallpapers/mode`
file. This mode will be an indicator for the wallpaper management scripts, of
which there are two:

1. `bkg` -- This script modifies which wallpapers (backgrounds) are selected for
    use, one per run. If the mode is `DAY`, it will change the wallpaper used
    for the current time of day. You may pass this script a single argument if
    you want to modify a different time of day. Ex: `bkg "Late Afternoon"` will
    modify the background selected for late afternoon, regardless of the current
    time. `ranger` is required for this script to function properly.

2. `update-wallpaper` -- This script applies the appropriate wallpaper according
    to the contents of `~/.wallpapers/mode` and any other external factors (eg,
    the current time). Your scheduled job should run this script on a regular
    interval. It is also run by `~/.xinitrc` (ie, on X11 startup)

Note: If the contents of the `~/.wallpapers/mode` file are not recognized, 
"Normal" mode is assume.

### Sublime Text Theme

To use the Sublime Text theme, install the
[colorsublime](http://colorsublime.com/) plugin. Run the included `applyxres`
utility script to generate the theme. Then, within Sublime, select
"Xres-Generated" from within the "Preferences > Color Schemes > Colorsublime-Themes"
menu in Sublime.

Note: If you try to open vim while Sublime Text is open, Powerline will have a
dramatic freakout session. I don't know why this happens. Once you close Sublime
Text, vim will open normally.

### Other Notes

For my `.vimrc` to work, you'll need [Vundle](https://github.com/VundleVim/Vundle.vim).

## Usage

### Scripts

I've written the following utiliy scripts to manage the system:

* `applyxres` -- Python script that will apply the colors defined in
  `~/.Xresources` to color configuration throughout the system.
* `batmon` -- Basically userless battery monitor, but hey, maybe you'll find a
  reason to use it. :shrugs: Use Ctrl+c to exit.
* `batpct` -- Outputs battery percentage to four points of percision. I used to
  use this for the bar until I replaced it with `batstat`, and still use it as
  a quick way to check my battery life on startup before I start X11.
* `batstat` -- Outputs concise battery information, used for lemonbar.
* `bkg` -- Script used to manage selected background images. Described above.
* `frame` -- Old script from when I was using XFCE, before I leared about the
  wonderous power of i3-gaps. The script attempts to place the window in the
  center of the screen with a small amount of padding around the edges.
* `gaps` -- Modifies the window gaps provided by `i3-gaps`. Takes a descriptive
  string, either "pretty", "work", or "focus", or a pair of integers to manually
  set the outer and inner gaps for the current workspace, respectively.
* `myres` -- Terrible, rotten screen resolution script, don't use it.
* `myrofi` -- Custom rofi launching script, one of the targets for `applyxres`
* `timeofday` -- Prints out a string describing the time of day, which can be
  either "Late Night", "Early Morning", "Morning", "Afternoon", "Late Afternoon"
  "Evening", or "Night"
* `update-wallpaper` -- Sets the currently appropriate wallpaper, described above.
* `volume-status` -- Old volume status script, superceded by volume-status-2. I
  don't know why I keep it around.
* `volume-status-2` -- New volume status script, used by bar.
* `wallpaper.init` -- Sets up `~/.wallpapers`. See above for more details.
* `wifimode` -- Allows you to quickly change your wlan interface's operating
  mode. You'll have to change the iname variable in the script to the name of
  your interface if it differs from the preset one. Ex: `sudo wifimode Monitor`

The rest of the scripts aren't my own-- they should all have attributions writen
in them (except for bar, which is simply the lemonbar binary)

### Colors

I wrote `applyxres` to streamline color theming in my system. All you have to do
to change your system's color scheme is edit your `~/.Xresources` file and run
`applyxres`. Some of the changes won't be visible until you reboot.

### Keybindings

Refer to `~/.i3/config` for keybindings-- it's mostly stock, with a few changes.
Arrow keys are disabled in favor of vim-style movement. Same thing for `.vimrc`.

Exit i3 with Super+Shift+e, but be advised that there is a bug in electro7's
bar scripts that causes perl to explode after logging out. You should either
immediately poweroff or reboot, or kill off perl (`pkill perl`) to save your CPU
from being tortured. I hope this gets fixed one day.
