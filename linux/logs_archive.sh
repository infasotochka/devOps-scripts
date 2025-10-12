#!/bin/bash

# Script for creating an archive of logs

LOG_DIR=$1
start_time=$SECONDS

if [ -z "$LOG_DIR" ]; then
    echo -e "\033[31mError: the directory is not specified\033[0m"
    exit 1
fi

if [ ! -d "$LOG_DIR" ]; then
    echo -e "\033[31mError: invalid directory\033[0m"
    exit 1
fi


echo -e "\033[33mSelected directory is $LOG_DIR\033[0m"
echo -e "\033[33mMaking an archive...\033[0m"

FILE_NAME="logs_archive_$(date +%Y-%m-%d__%H-%M-%S).tar.gz"
tar -czf "$FILE_NAME" "$LOG_DIR" > /dev/null


result=$(( SECONDS - start_time ))
minutes=$(( result / 60))
seconds=$(( result % 60))
echo -e "\033[32mSuccessfully!\033[0m"
echo -e "\033[32mFinal size: $(du -h "$FILE_NAME" | awk '{print $1}')\033[0m"
printf "\033[32mExecution time: %02d:%02d (min:sec)\033[0m\n" $minutes $seconds
