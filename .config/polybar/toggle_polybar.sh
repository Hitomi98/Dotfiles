#!/bin/sh

var=$(pgrep --exact polybar)
# echo $var

if [ -z "$var" ]
then
    # Create a log file for the bar
	echo "---" | tee -a /tmp/polybar.log

	#if type "xrandr"; then
	for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
		MONITOR=$m polybar barprincipale >>/tmp/polybar.log 2>&1
	done
	echo "Bars launched..."

else
	#echo "\$var is NOT empty"
	#kill $(pgrep polybar)
	killall -q polybar
fi
