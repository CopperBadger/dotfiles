#!/usr/bin/python3

# Read .Xresources color definitions and copy them into my files:
# 1. i3 configuration
# 2. Xfce4 Terminal
# 3. i3 Lemonbar configuration
# 4. Powerline
# 5. My custom rofi script

import re
import json
import os
from hex2x11 import BestMatch

find_pat = re.compile("(?:([a-zA-Z0-9]+):\s*#(.{6}))")
home = os.environ['HOME']

# Open user's .Xresources
# TODO -- If file doesn't exist, try .Xdefaults, and then finally error
f = open(home+"/.Xresources", "r")

# Read the colors from the file! Here's a sample:
#
# !URxvt*background: #3f3f3f
# !URxvt*foreground: #dcdccc
# !URxvt*color0: #3f3f3f
# ...
# !URxvt*color15: #ffffff
#
# The "!URxvt*" prefix may not be there, don't rely on it

definitions = {}
lookup = {
  "foreground": "c_foreground",
  "background": "c_background",
  "cursorColor": "c_cursor",
  "color0": "c_black_d",
  "color8": "c_black_l",
  "color1": "c_red_d",
  "color9": "c_red_l",
  "color2": "c_green_d",
  "color10": "c_green_l",
  "color3": "c_yellow_d",
  "color11": "c_yellow_l",
  "color4": "c_blue_d",
  "color12": "c_blue_l",
  "color5": "c_magenta_d",
  "color13": "c_magenta_l",
  "color6": "c_cyan_d",
  "color14": "c_cyan_l",
  "color7": "c_white_d",
  "color15": "c_white_l"
}
colors = {}
for line in f:
  tkn = find_pat.findall(line)
  if len(tkn) and tkn[0][0] in lookup:
    colors[lookup[tkn[0][0]]] = tkn[0][1]

# Close the file cause we're done with it
f.close()

# If there are any missing colors, we need to put them in (use FFF000)
for k in lookup:
  if lookup[k] not in colors:
    colors[lookup[k]] = "fff000"

def replace_in_file(fname, replacement, begin="# --- APPLY XRES BEGIN", end="# --- APPLY XRES END"):
  f = open(fname, "r")
  lines = f.readlines()
  idx = sidx = eidx = 0
  
  for l in lines:
    if l == begin+"\n":
      sidx = idx + 1
    elif l == end+"\n":
      eidx = idx - 1
    idx += 1
  
  f.close()
  
  if not begin:
    print("Error: "+fname+": could not find beginning line");
  elif not end:
    print("Error: "+fname+": could not find end line");
  else:
    while eidx >= sidx:
      lines.pop(eidx)
      eidx -= 1
  
    lines.insert(sidx, replacement+"\n")
    
    
    f = open(fname, "w")
    f.write("".join(lines))
    f.close()

def hex_lighten(hexvalue, n):
  hexvalue = hexvalue.lower()
  out = ""
  for i in range(0,3):
    out += hex(max(min(int(hexvalue[i*2:(i*2)+2], base=16)+n,255),0))[2:]
    if len(out) % 2:
     out += "0"
  return out

### ------------------------------------------------------------------------- 
### ------------------------- Apply colors to files -------------------------
### ------------------------------------------------------------------------- 

# 1. i3 configuration file
repl = []

for k in colors:
  repl.append("set $"+k+" #"+colors[k])

repl = "\n".join(repl)
replace_in_file(home+"/.i3/config", repl)

# 2. XFCE4 Terminalrc (this is really stupid, oh well)
arr = []

def double_color(c):
  return (c[:2]*2)+(c[2:4]*2)+(c[4:6]*2)

for i in range(0,16):
  c = colors[lookup["color"+str(i)]]
  c = double_color(c)
  arr.append("#"+c)

repl = "ColorForeground=#"+double_color(colors['c_foreground'])+"\nColorBackground=#"+double_color(colors['c_background'])+"\nColorCursor=#"+double_color(colors['c_cursor'])+"\n"

repl += "ColorPalette="+(";".join(arr))
replace_in_file(home+"/.config/xfce4/terminal/terminalrc", repl)

# 3. i3 Lemonbar configuration
arr = []

for k in colors:
  arr.append(k+"=\"#ff"+colors[k]+"\"")

replace_in_file(home+"/.i3/lemonbar/i3_lemonbar_config", "\n".join(arr))

# 4. Powerline colors
# "white": "c_white_l",

relations = {
  "black": "c_black_d",
  "green": "c_green_l",
  "darkestgreen": "c_green_d",
  "darkgreen": "c_green_d",
  "mediumgreen": "c_green_l",
  "brightgreen": "c_green_l",
  "darkestcyan": "c_cyan_d",
  "darkcyan": "c_cyan_d",
  "mediumcyan": "c_cyan_l",
  "brightcyan": "c_cyan_l",
  "darkestblue": "c_blue_d",
  "darkblue": "c_blue_d",
  "red": "c_red_l",
  "darkestred": "c_red_d",
  "darkred": "c_red_d",
  "mediumred": "c_red_l",
  "brightred": "c_red_l",
  "brightestred": "c_red_l",
  "darkestpurple": "c_magenta_d",
  "mediumpurple": "c_magenta_d",
  "brightpurple": "c_magenta_l",
  "darkorange": "c_red_d",
  "mediumorange": "c_red_d",
  "brightorange": "c_red_l",
  "brightestorange": "c_red_l",
  "yellow": "c_yellow_l",
  "brightyellow": "c_yellow_l",
  "lightyellowgreen": "c_yellow_l",
  "gold3": "c_yellow_d",
  "orangered": "c_red_l",
  "steelblue": "c_black_l",
  "darkorange": "c_yellow_d",
  "skyblue": "c_cyan_l",
  "khaki1": "c_white_d"
}

contrast = 12
tint_lookup = {
  "dark": -3 * contrast,
  "darkest": -5 * contrast,
  "bright": 2 * contrast,
  "brightest": 5 * contrast,
  "medium": -1 * contrast,
}

f = open("/usr/lib/python3.4/site-packages/powerline/config_files/colors.json.default", "r")
src = json.load(f)
f.close()

plcolors = src['colors']
for k in plcolors:
  if k in relations:
    for t in tint_lookup:
      col = colors[relations[k]]
      if k.find(t) > -1:
        col = hex_lighten(col, tint_lookup[t])
      src['colors'][k] = int(BestMatch(col))

f = open("/usr/lib/python3.4/site-packages/powerline/config_files/colors.json", "w")
json.dump(src,f,indent=2)
f.close()

# 5. rofi script

arr = []

for k in colors:
  arr.append(k+"=\""+colors[k]+"\"")

replace_in_file(home+"/sbin/myrofi", "\n".join(arr))

# 6. Sublime Text theme

f = open(home+"/.config/sublime-text-3/Packages/Colorsublime-Themes/Xres-Generated.tmTheme", "w")
template = open(home+"/.config/sublime-text-3/Packages/User/ApplyXres.template", "r")

header = """<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
\t<key>name</key>
\t<string>APPLYXRES Generated Theme</string>
\t<key>settings</key>
\t<array>
"""

f.write(header)

template_lines = template.readlines()
plist_pat = re.compile("^(\s*)([a-zA-Z0-9]+)(:)?(?:\s+(.+))?$")

inDict = 0
def numsp():
  return "\t"*(inDict+2)

def write_tag(name, value):
  f.write(numsp()+"<{0}>{1}</{0}>\n".format(name, value))

for line in template_lines:
  if not line.strip():
    while inDict > 0:
      inDict -= 1
      f.write(numsp()+"</dict>\n")
    continue

  if inDict == 0:
    f.write(numsp()+"<dict>\n")
    inDict = 1

  tkn = plist_pat.findall(line)
  if len(tkn) and len(tkn[0]) == 4:
    tkn = tkn[0]
    write_tag("key", tkn[1])
    if len(tkn[-1]):
      value = tkn[-1]
      if tkn[-1][0] == "$":
        cname = value[1:]
        if cname in colors:
          value = "#"+colors[cname]
        else:
          print("Sublime Text template error: color \""+value+"\" not found")
          value = "#FFF000"
      write_tag("string", value)
    elif len(tkn[2]):
      f.write(numsp()+"<dict>\n")
      inDict += 1
  else:
    print("Error: bad line",line)

while inDict > 0:
  inDict -= 1
  f.write(numsp()+"</dict>\n")

footer = """\t</array>
</dict>
</plist>
"""

f.write(footer)

template.close()
f.close()
