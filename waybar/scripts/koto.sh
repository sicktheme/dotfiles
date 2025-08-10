#!/bin/bash
season=$(date +"%m")
case $season in
  12|01|02) echo "☯ 冬" ;; # Зима
  03|04|05) echo "☯ 春" ;; # Весна
  06|07|08) echo "☯ 夏" ;; # Лето
  09|10|11) echo "☯ 秋" ;; # Осень
esac
