#!/bin/bash
#
# Input parser for i3 bar
# 14 ago 2015 - Electro7

# config
. $(dirname $0)/i3_lemonbar_config

# min init
irc_n_high=0
title="%{F${color_head} B${color_sec_b2}}${sep_right}%{F${color_head} B${color_sec_b2}%{T2} ${icon_prog} %{F${color_sec_b2} B-}${sep_right}%{F- B- T1}"

# parser
while read -r line ; do
  case $line in
    SYS*)
      # conky=, 0 = wday, 1 = mday, 2 = month, 3 = time, 4 = cpu, 5 = mem, 6 = disk /, 7 = disk /home, 8-9 = up/down wlan, 10-11 = up/down eth, 12-13=speed
      sys_arr=(${line#???})

      # date
      if [ ${res_w} -gt 1024 ]; then
        date="${sys_arr[0]} ${sys_arr[1]} ${sys_arr[2]}"
      else
        date="${sys_arr[1]} ${sys_arr[2]}"
      fi
      date="%{F${color_sec_b1}}${sep_left}%{F${color_icon} B${color_sec_b1}} %{T2}${icon_clock}%{F- T1} ${date}"

      # time
      time="%{F${color_clock_edge}}${sep_left}%{F${color_clock} B${color_clock_edge}}${sep_left}%{F${color_back} B${color_clock}} ${sys_arr[3]} %{F- B-}"

      # cpu
      if [ ${sys_arr[4]} -gt ${cpu_alert} ]; then
        cpu_cback=${color_cpu}; cpu_cicon=${color_back}; cpu_cfore=${color_back};
      else
        cpu_cback=${color_sec_b2}; cpu_cicon=${color_icon}; cpu_cfore=${color_fore};
      fi
      cpu="%{F${cpu_cback}}${sep_left}%{F${cpu_cicon} B${cpu_cback}} %{T2}${icon_cpu}%{F${cpu_cfore} T1} ${sys_arr[4]}%%"

      # mem
      mem="%{F${cpu_cicon}}${sep_l_left} %{T2}${icon_mem}%{F${cpu_cfore} T1} ${sys_arr[5]}"

      # disk /
      # diskr="%{F${color_sec_b1}}${sep_left}%{F${color_icon} B${color_sec_b1}} %{T2}${icon_hd}%{F- T1} ${sys_arr[6]}%%"

      # disk home
      # diskh="%{F${color_icon}}${sep_l_left} %{T2}${icon_home}%{F- T1} ${sys_arr[7]}%%"

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
      wland="%{F${wlan_cback}}${sep_left}%{F${wlan_cicon} B${wlan_cback}} %{T2}${icon_dl}%{F${wlan_cfore} T1} ${wland_v}"
      wlanu="%{F${wlan_cicon}}${sep_l_left} %{T2}${icon_ul}%{F${wlan_cfore} T1} ${wlanu_v}"

      # eth
      # if [ "${sys_arr[10]}" == "down" ]; then
      #   ethd_v="×"; ethu_v="×";
      #   eth_cback=${color_sec_b1}; eth_cicon=${color_disable}; eth_cfore=${color_disable};
      # else
      #   ethd_v=${sys_arr[10]}K; ethu_v=${sys_arr[11]}K;
      #   if [ ${ethd_v:0:-3} -gt ${net_alert} ] || [ ${ethu_v:0:-3} -gt ${net_alert} ]; then
      #     eth_cback=${color_net}; eth_cicon=${color_back}; eth_cfore=${color_back};
      #   else
      #     eth_cback=${color_sec_b1}; eth_cicon=${color_icon}; eth_cfore=${color_fore};
      #   fi
      # fi
      # ethd="%{F${eth_cback}}${sep_left}%{F${eth_cicon} B${eth_cback}} %{T2}${icon_dl}%{F${eth_cfore} T1} ${ethd_v}"
      # ethu="%{F${eth_cicon}}${sep_l_left} %{T2}${icon_ul}%{F${eth_cfore} T1} ${ethu_v}"
      ;;

    VOL*)
      # Volume:
      #   [0] Muted indicator: (M=Muted / (anything else)=Unmuted)
      #   [1] On/off (muted) status (1=Unmuted / 0=Muted)
      vol_arr=(${line#???})
      vol_bkg=$color_sec_b2
      vol_frg=$color_fore
      vol_ico=$icon_vol
      vol_txt=${vol_arr[1]}
      if [[ ${vol_arr[0]} == "M" ]]; then
        vol_bkg=$color_sec_b1
        vol_frg=$color_icon
        vol_ico=$icon_mute
      fi
      vol="%{F${vol_bkg}}${sep_left}%{F${color_icon} B${vol_bkg}} %{T2}${vol_ico}%{F${vol_frg} T1} $vol_txt%{F${color_fore}}"
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

    IRC*)
      # IRC highlight (script irc_warn)
      if [ "${line#???}" != "0" ]; then
        ((irc_n_high++)); irc_high="${line#???}";
        irc_cback=${color_chat}; irc_cicon=${color_back}; irc_cfore=${color_back}
      else
        irc_n_high=0; [ -z "${irc_high}" ] && irc_high="none";
        irc_cback=${color_sec_b2}; irc_cicon=${color_icon}; irc_cfore=${color_fore}
      fi
      irc="%{F${irc_cback}}${sep_left}%{F${irc_cicon} B${irc_cback}} %{T2}${icon_chat}%{F${irc_cfore} T1} ${irc_n_high} %{F${irc_cicon}}${sep_l_left} %{T2}${icon_contact}%{F${irc_cfore} T1} ${irc_high}"
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
      mpd="%{F${color_sec_b2}}${sep_left}%{B${color_sec_b2}}%{F${color_sec_b1}}${sep_left}%{F${color_icon} B${color_sec_b1}} %{T2}${icon_music}%{F${color_fore} T1}  ${song}"
      # echo "Setting music display to ${song}" >> bar.log
      ;;

    BAT*)
      # Battery readout:
      #   [0] = integer part
      #   [1] = charging status (D(ischarging), C(harging))
      #   [2] = power level (F(ull), N(ormal), L(ow), C(ritical))
      bat_arr=(${line#???})
      bat_icons=($icon_battery)
      ico="${bat_icons[$(((${bat_arr[0]}*(${#bat_icons[@]}-1))/100))]}"
      bkg="${color_sec_b1}"
      frg="${color_fore}"

      if [[ ${bat_arr[2]} == "L" ]]; then
        bkg="${color_warning}"
        frg="${color_back}"
      elif [[ ${bat_arr[2]} == "C" ]]; then
        bkg="${color_critical}"
        frg="${color_back}"
      elif [[ ${bat_arr[2]} == "F" ]]; then
        bkg="${c_green_d}"
        frg="${c_white_l}"
      fi

      batamt="%{F${bkg}}${sep_left}%{B${bkg}} %{F${frg}} ${ico} ${bat_arr[0]}%%"

      if [[ ${bat_arr[1]} == "C" ]]; then
        batamt="%{F${color_fore}}${sep_left}%{F${color_back} B${color_fore}}${icon_charging}${batamt}"
      fi
      ;;

    WSP*)
      # I3 Workspaces
      wsp="%{F${color_back} B${color_head}} %{T2}${icon_wsp}%{T1} "
      set -- ${line#???}
      while [ $# -gt 0 ] ; do
        case $1 in
         FOC*)
           wsp="${wsp}%{F${color_head} B${color_wsp}}${sep_right}%{F${color_back} B${color_wsp} T1} ${1##????} %{F${color_wsp} B${color_head}}${sep_right}"
           ;;
         INA*|URG*|ACT*)
           wsp="${wsp}%{F${color_back} T1} ${1##????} "
           ;;
        esac
        shift
      done
      ;;
      
    WIN*)
      # window title
      title=$(xprop -id ${line#???} | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2)
      title="%{F${color_head} B${color_sec_b2} T1}${sep_right}%{F${color_icon} B${color_sec_b2} T2} ${icon_prog} %{F${color_sec_b2} B- T1}${sep_right}%{F- B- T1} ${title}"
      ;;

    WNM*)
      # Window title (string)
      title=$(echo ${line#???} | xargs)
      title="%{F${color_head} B${color_sec_b2} T1}${sep_right}%{F${color_icon} B${color_sec_b2} T2} ${icon_prog} %{F${color_sec_b2} B- T1}${sep_right}%{F- B- T1} ${title}"
      ;;

    VIS*)
      # Visual effects
      viscmds=(${line#???})
      ;;

    MSG*)
      viscmds=(`echo "fill ${color_sec_b2} ${color_fore}"`)
      msg=${line#???}
      ;;

    WRN*)
      viscmds=(`echo "fill ${color_warning} ${color_back}"`)
      msg=${line#???}
      ;;

    ALT*)
      viscmds=(`echo "fill ${color_critical} ${color_back}"`)
      msg=${line#???}
      ;;
      
  esac

  # And finally, output
  if [[ ${viscmds[0]} == "fill" ]]; then
    printf "%s\n" "%{l}%{B${viscmds[2]}}   %{B${viscmds[1]} F${viscmds[2]}}${sep_right} ${msg} %{r}%{B${viscmds[1]} F${viscmds[2]}}"
  else
    printf "%s\n" "%{l}${wsp}${title} %{r}${mpd}${stab}${wland}${stab}${wlanu}${stab}${vol}${stab}${cpu}${stab}${mem}${stab}${batamt}${stab}${date}${stab}${time}"
  fi
done
