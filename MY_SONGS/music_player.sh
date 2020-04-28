#!/bin/sh
if [ ! -e /sys/class/gpio/gpio23/direction ] ;
then
echo "23" > /sys/class/gpio/export
echo "22" > /sys/class/gpio/export
echo "27" > /sys/class/gpio/export
echo "17" > /sys/class/gpio/export

echo "in" > /sys/class/gpio/gpio23/direction
echo "in" > /sys/class/gpio/gpio22/direction
echo "in" > /sys/class/gpio/gpio27/direction
echo "in" > /sys/class/gpio/gpio17/direction
fi
index=1
path=../MY_SONGS/S
madplay -Q --no-tty-control $path$index.mp3 &
song_pid=$!
status=0

while :
do
	if [ $(cat /sys/class/gpio/gpio17/value) -eq 1 ]
	then
		sleep 0.3
		if [ $status -eq 0 ]
		then
			kill -19 $song_pid
			status=1
			echo "pause"
		else
			kill -18 $song_pid
			status=0
			echo "play"
		fi
		

	elif [ $(cat /sys/class/gpio/gpio27/value) -eq 1 ]
	then
		sleep 0.3
		echo "next"
		if [ $index -eq 4 ]
		then
			index=1
		else
			index=$(($index+1))
		fi

		kill -9 $song_pid
		madplay -Q --no-tty-control $path$index.mp3 & 
		song_pid=$!

	elif [ $(cat /sys/class/gpio/gpio22/value) -eq 1 ]
	then
		sleep 0.3
		echo "previous"
		if [ $index -eq 1 ]
		then
			index=4
		else
			index=$(($index-1))
		fi
		
		kill -9 $song_pid
		madplay -Q --no-tty-control $path$index.mp3 &
		song_pid=$!

	elif [ $(cat /sys/class/gpio/gpio23/value) -eq 1 ]
	then
		sleep 0.3
		echo "stop"
		kill -9 $song_pid
	fi
done &
