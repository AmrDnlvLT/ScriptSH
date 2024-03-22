#! /bin/bash

pid=`pgrep java`

echo "Pid process $pid"
kill -9 $pid
echo "Kill process"

rm -f /home/.../logs/*
rm -f /home/.../nohup.out

echo "Delete logs and nohup"
echo "Start service"

nohup /app/.../jdk1.8.0_181/bin/java -Xms512m -Xmx4096 -jar /app/.../STUB-1.0-SNAPHOT.jar > /app/.../LogsNoHup/nohup.out > &1 &