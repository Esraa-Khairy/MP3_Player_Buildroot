#!/bin/bash

prev_state=0
mediaParitions=()

while true; do
        partitions="$(fdisk -l /dev/sd* | grep -v 'Unknown' | grep -v 'Empty'  | >
        for partition in $partitions;
          do
          mountpoint="/media/$(basename $partition)"
          mkdir -p $mountpoint
          mount $partition $mountpoint
        done

        pureDevice=()

        for umountPartion in $partitions;
                do
                        umountPoint="/media/$(basename $umountPartion)"
                        check=`ls $umountPoint | wc -l`
                        if [[ $check == '0' ]]
                                then
                                umount $umountPoint
                                rm -r $umountPoint
                        fi
                done


        if [[ ${#partitions[@]} -eq prev_state ]]
        then
                x=1
        #do nothing
        else
        echo 1 > /Project/Global_Flag
        fi

        prev_state=${#partitions[@]}

done




