#!/bin/bash

#script for viewing the load on the server 

echo "=============SERVER STATIC============"
echo
echo "---------CPU USAGE----------------------"
top -bn1 | grep "load average" | awk -F'load average: ' '{print "Load average "$2}'
top -bn1| grep "Cpu"
echo
echo "---------RAM USAGE----------------------"
free -h | grep total
free -h | grep Mem
echo
echo "---------DISK USAGE---------------------"
df -h --total | grep total
echo
echo "---------Top 5 processes by CPU usage---"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
echo
echo "---------Top 5 processes by MEM usage---"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6
