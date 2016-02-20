#!/bin/bash
#
# Input parser for i3 bar
# 14 ago 2015 - Electro7

# config
. $(dirname $0)/i3_lemonbar_config

# min init
irc_n_high=0
# title="%{F${color_head} B${color_sec_b2} T3}${sep_right}%{F${color_head} B${color_sec_b2}}%{T2} ${icon_prog} %{F${color_sec_b2} B- T3}${sep_right}%{F- B- T1}"
title="%{F${color_head} B${color_sec_b2} T2} ${icon_prog} %{T1}"

# parser
while read -r line ; do
  case $line in
    SYS*)
      # conky=, 0 = wday, 1 = mday, 2 = month, 3 = time, 4 = cpu, 5 = mem, 6 = disk /, 7 = disk /home, 8-9 = up/down wlan, 10-11 = up/down eth, 12-13=speed
      sys_arr=(${line#???})

      # date
      date="${sys_arr[0]} ${sys_arr[1]} ${sys_arr[2]}"
      date="%{B${color_bgdarkhl} T2}   ${icon_calendar} %{T1} ${date}"

      # time
      time="%{T2}${icon_clock}  %{T1}${sys_arr[3]}   %{F- B-}"

      # cpu
      cpu="%{T2}  ${icon_cpu}  %{T1}${sys_arr[4]}% %{F- B-}"
      # cpu="%{F${cpu_cback} T3}${sep_left}%{F${cpu_cicon} B${cpu_cback}} %{T2}${icon_cpu}%{F${cpu_cfore} T1} ${sys_arr[4]}%%"

      # mem
      mem="%{F${cpu_cicon} T3}${sep_l_left} %{T2}${icon_mem}%{F${cpu_cfore} T1} ${sys_arr[5]}"

      # wlan
      if [ "${sys_arr[8]}" == "down" ]; then
        wland_v="×"; wlanu_v="×";
        wlan_cback=${color_sec_b2}; wlan_cicon=${color_sec_b3}; wlan_cfore=${color_sec_b3};
      else
        wland_v=${sys_arr[8]}K; wlanu_v=${sys_arr[9]}K;
        if [ ${wland_v:0:-3} -gt ${net_alert} ] || [ ${wlanu_v:0:-3} -gt ${net_alert} ]; then
          wlan_cback=${color_net}; wlan_cicon=${color_back}; wlan_cfore=${color_back};
        else
          wlan_cback=${color_sec_b2}; wlan_cicon=${color_icon}; wlan_cfore=${color_fore};
        fi
      fi
      wland="%{F${color_fgdark} T2}  ${icon_dl} %{T1} ${wland_v}  "
      wlanu="%{T2}  ${icon_ul} %{T1} ${wlanu_v}  "
      ;;

    VOL*)
      # Volume:
      #   [0] Muted indicator: (M=Muted / (anything else)=Unmuted)
      #   [1] On/off (muted) status (1=Unmuted / 0=Muted)
      vol_arr=(${line#???})
      vol_frg=-
      vol_oln=-
      vol_ico=$icon_vol
      vol_txt=${vol_arr[1]}
      if [[ ${vol_arr[0]} == "M" ]]; then
        vol_frg=${color_fgdark}
        vol_ico="${icon_mute}  "
      fi
      vol="%{B- F${vol_frg} T2}  ${vol_ico} %{T1} ${vol_txt}%{F- B-}"
      ;;

    GMA*)
      # Gmail
      gmail="${line#???}"
      if [ "${gmail}" != "0" ]; then
        mail_cback=${color_mail}; mail_cicon=${color_back}; mail_cfore=${color_back}
      else
        mail_cback=${color_sec_b1}; mail_cicon=${color_icon}; mail_cfore=${color_fore}
      fi
      gmail="%{F${mail_cback}}${sep_left}%{F${mail_cicon} B${mail_cback}} %{T2}${icon_mail}%{F${mail_cfore} T1} ${gmail}"
      ;;

    MPD*)
      # Music
      mpd_arr=(${line#???})
      if [ -z "${line#???}" ]; then
        song="none";
      elif [ "${mpd_arr[1]}" == "error:" ]; then
        song="mpd off";
      else
        song="${line#???}";
      fi
      mpd="%{T2}${icon_music} %{F- T1}  ${song}"
      # echo "Setting music display to ${song}" >> bar.log
      ;;

    BAT*)
      # Battery readout:
      #   [0] = integer part
      #   [1] = charging status (D(ischarging), C(harging))
      #   [2] = power level (F(ull), N(ormal), L(ow), C(ritical))
      bat_arr=(${line#???})
      bat_icons=($icon_battery)
      if [[ ${bat_arr[1]} == "C" ]]; then
        ico="${icon_charging} "
      else
        ico="${bat_icons[$(((${bat_arr[0]}*(${#bat_icons[@]}-1))/100))]}"
      fi
      bkg=-
      frg="${color_fglight}"
      oln="${bkg}"

      if [[ ${bat_arr[2]} == "L" ]]; then
        oln="${color_warning}"
        bkg="${color_bgdarkhl}"
      elif [[ ${bat_arr[2]} == "C" ]]; then
        oln="${color_critical}"
        bkg="${color_critical}"
      elif [[ ${bat_arr[2]} == "F" ]]; then
        oln="${color_success}"
        bkg="${color_bgdarkhl}"
      fi

      batamt="%{+u U${oln} B${bkg}} %{F${frg} T2} ${ico} %{T1}${bat_arr[0]}%  %{-u B-}"
      ;;

    WSP*)
      # I3 Workspaces
      wsp="%{F${color_fglight} B${color_bgdark} T1}"
      set -- ${line#???}
      while [ $# -gt 0 ] ; do
        case $1 in
         FOC*)
           wsp="${wsp}%{+u B${color_bgdarkhl} U${color_accent1} T1}   ${1##????}   %{-u B${color_bgdark} F${color_fglight}}"
           ;;
         INA*|URG*|ACT*)
           wsp="${wsp}%{F${color_fglight} T1}   ${1##????}   "
           ;;
        esac
        shift
      done
      ;;
      
    WIN*)
      # window title
      title=$(xprop -id ${line#???} | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2)
      title=" %{F- B- T1} ${title}"
      ;;

    SID*)
      ssid="%{F${color_fgdark} T2}  ${icon_ssid}  %{T1}${line#???}"
      ;;
      
  esac

  # And finally, output
  printf "%s\n" "%{U${color_accent1} l}${wsp} %{r}${ssid}${stab}${cpu}${stab}${vol}${stab}${batamt}${date}${stab}${time}"
done
