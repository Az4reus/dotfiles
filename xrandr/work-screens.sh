#!/bin/sh
xrandr --output eDP1 --primary --mode 1920x1080 --pos 5120x360 --rotate normal 
xrandr --output DP2-1 --mode 2560x1440 --pos 2560x0 --rotate normal 
xrandr --output DP2-2 --mode 2560x1440 --pos 0x0 --rotate normal 
xrandr --output DP2-3 --off 
xrandr --output HDMI2 --off 
xrandr --output HDMI1 --off 
xrandr --output DP2 --off
xrandr --output DP1 --off
xrandr --output VIRTUAL1 --off 
