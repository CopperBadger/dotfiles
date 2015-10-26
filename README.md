# Dotfiles
---

Welcome to my dotfiles! I hope you have a wonderful time.

## Installation

### General

1. First, install the dependencies listed in the following section.

2. `util/` contains my custom utility scripts. Place them in a directory
  contained within your `$PATH` and ensure that they are executable.

3. All of the contents of `dots/` should be placed in your home directory,
  except for:
    * `compton.conf`, which should be placed in `~/.config/compton` (create this
      directory if it does not already exist.
    * `terminalrc`, the xfce4-terminal configuration, which should be placed in
      `~/.config/xfce4/terminal` (create this directory if it does not already
      exist)
    * `ApplyXres.template`, if you use Sublime Text, which should be placed in
      `~/.config/sublime-text-3/Packages/User`. See the "Sublime Text theme"
      section for more info.
    * `bkg.service` and `bkg.timer`, two systemd units that automate background
      switching. If you use systemd, place them in your installation's unit
      directory.

### Wallpapers

Run the `wallpaper.init` script to set up your `~/.wallpapers` directory. You
will need to supply the path for a default background image. To cancel, press
Ctrl+c. Also ensure that you have `feh` installed.

My setup has three modes for wallpaper display:

1. "Normal" -- One wallpaper is displayed all of the time.
2. `DAY` -- A series of wallpapers cycle through the day, according to the
    output of the `timeofday` utility script.
3. `RANDOM` -- (Not yet implemented) Will select a random image from a directory
    at regular intervals.

The latter two require a scheduled job to trigger the `update-wallpaper` script
(described below). If you use systemd, you may simply review and install the
included `bkg.service` and `bkg.timer` units. If you do not use systemd, you
will have to schedule the job yourself.

One of these three modes should be the sole contents of the `~/.wallpapers/mode`
file. This mode will be an indicator for the wallpaper management scripts, of
which there are two:

1. `bkg` -- This script modifies which wallpapers (backgrounds) are selected for
    use, one per run. This will modify your set background image. If the mode is
    `DAY`, it will change the wallpaper used for the current time of day. You
    may pass this script a single argument if you want to modify a different
    time of day. Ex: `bkg "Late Afternoon"` will modify the background selected
    for late afternoon, regardless of the current time. `ranger` is required for
    this script to function properly.

2. `update_wallpaper` -- This script applies the appropriate wallpaper according
    to the contents of `~/.wallpapers/mode` and any other external factors (eg,
    the current time). Your scheduled job should run this script on a regular
    interval. It is also run by `~/.xinitrc` (ie, on X11 startup)

Note: If the contents of the `~/.wallpapers/mode` file are not recognized, the
"Normal" mode is assume.

### Sublime Text Theme

To use the Sublime Text theme, install the
[colorsublime](http://colorsublime.com/) plugin. Run the included `applyxres.py`
utility script to generate the theme. Then, within Sublime, select
"Xres-Generated" from within the "Preferences > Color Schemes > Colorsublime-Themes"
menu.

### Other Notes

For my `.vimrc` to work, you'll need [Vundle](https://github.com/VundleVim/Vundle.vim)


## Dependencies

*Note: I might forget something here. Open a ticket if you believe that
something is missing*

This setup is intended for **[i3-gaps](https://github.com/Airblader/i3)** by
Airblader. I haven't tested it with regular i3, you'll probably have to make
a few changes.

### Required

* `compton` -- Compositor
* `feh` -- Background setting program and image viewer
* `mpd` -- Music Player Daemon. Plays music for you, provides lemonbar with
  info about playing media. I recommend `ncmpcpp` as the client.
  ([Setup](https://wiki.archlinux.org/index.php/Music_Player_Daemon#Setup))
* `iwconfig` -- Wireless interface configuration tool, used only for `wifimode`
* [Powerline](http://powerline.readthedocs.org/en/master/) -- Statusline plugin
  for multiple components. Needed for `vim` and `tmux` styling.
* `pulseaudio` -- If you don't like pulseaudio, that's okay. You'll just have
  to do a little work yourself to get the volume scripts, media key bindings,
  and shell aliases to work for whatever setup you have.
* `ranger` -- Terminal file browser. Used in `bkg` script to easily browse
  available wallpapers.
* `rofi` -- Super-spiffy launcher.
* `xfce4-terminal` -- Terminal emulator, the only one supported by `applyxres.py`
   at the moment.

## Usage

I've written the following utiliy scripts to manage the system:

* `applyxres.py` -- Python script that will apply the colors defined in
  `~/.Xresources` to color configuration throughout the system.
* `batmon` -- Basically userless battery monitor, but hey, maybe you'll find a
  reason to use it. :shrugs: Use Ctrl+c to exit.
* `batpct` -- Outputs battery percentage to four points of percision. I used to
  use this for the bar until I replaced it with `batstat`, and still use it as
  a quick way to check my battery life on startup before I start X11.
* `batstat` -- Outputs concise battery information used in lemonbar.
* `bkg` -- Script used to manage selected background images. Described above.
* `frame` -- Old script from when I was using XFCE, before I leared about the
  POWER OF I3-GAPS, MUAHAHAHAHAHA!!! Attempts to place the window in the center
  of the screen with a small amount of padding around the edges.
* `gaps` -- Modifies the window gaps provided by `i3-gaps`. Takes a descriptive
  string, either "pretty", "work", or "focus", or a pair of integers to manually
  set the outer and inner gaps for the current workspace, respectively.
* `myres` -- Terrible, rotten screen resolution script, don't use it.
* `myrofi` -- Custom rofi launching script, one of the targets for `applyxres.py`
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

Refer to `~/.i3/config` for keybindings-- it's mostly stock, with a few changes.
Arrow keys are disabled in favor of vim-style movement.
