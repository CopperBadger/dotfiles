#!/bin/bash

hour=$(date "+%H")
hour=${hour#0*}
if (( hour >= 0 )) && (( hour <= 4 )); then
  # 12:00a - 4:59a
  echo "Late Night"
elif (( hour >= 5 )) && (( hour <= 7 )); then
  # 5:00a - 7:59a
  echo "Early Morning"
elif (( hour >= 8 )) && (( hour <= 11 )); then
  # 8:00a - 11:59p
  echo "Morning"
elif (( hour >= 12 )) && (( hour <= 15 )); then
  # 12:00p - 3:59p
  echo "Afternoon"
elif (( hour >= 16 )) && (( hour <= 17 )); then
  # 4:00p - 5:59p
  echo "Late Afternoon"
elif (( hour >= 18 )) && (( hour <= 20 )); then
  # 6:00p - 8:59p
  echo "Evening"
elif (( hour >= 21 )) && (( hour <= 23 )); then
  # 9:00p - 11:59p
  echo "Night"
fi
