#!/bin/sh
# Public domain

#LOG=entropy_avail.log
#touch $LOG

while true ; do
	cat /proc/sys/kernel/random/entropy_avail >> $LOG
	sleep 1
	tail -n 1 $LOG	
done
