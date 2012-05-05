#!/bin/bash
# Usage:myscp.sh -l server.cnf -f filename -s /path
# server.cnf
# file1 /mnt 22 root 192.168.1.110 localhost

COUNTS=0
my_scp()
{
	while read line
	do
		if [ ! -n "$line" ] ; then
			exit 1
		fi
		
		SERVPORT=`echo $line | awk '{print $3}'`
		USERNAME=`echo $line | awk '{print $4}'`
		IPADDRES=`echo $line | awk '{print $5}'`
		SERVNAME=`echo $line | awk '{print $6}'`
		echo $((COUNTS++)) > /dev/null
		printf "%4s Uploading %-20s to %-16s %-16s:%-20s\n" $COUNTS $FILENAME $SERVNAME $IPADDRES $SAVEPATH
		scp -P $SERVPORT $FILENAME $USERNAME@$IPADDRES:$SAVEPATH > /dev/null
		
	done < $SERVLIST
}

for i in "$@"
do 
    case "$i" in 
        -l)
            SERVLIST=$2
            shift 2
            ;;
        -f)
            FILENAME=$2
            shift 2
            ;;
        -s)
            SAVEPATH=$2
            my_scp
            shift 2
            ;;
    esac
done
exit 0