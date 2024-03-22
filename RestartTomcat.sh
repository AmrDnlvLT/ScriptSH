#! /bin/bash


if [[ $1 == "delete"]]
then
	rm -f /app/stubs/.../logs/*
	if [[ $? -eq 0 ]]
	then
		echo "Delete logs"
	else
		echo "ERROR: log is not delete"
	fi
else

	pid=`grep java`
	echo "Pid process $pid"
	
	kill -9 $pid
	
	if [[ $? -eq 0 ]]
	then
		echo "Kill process"
	else
		echo "ERROR: process is not kill"
	fi
		
	rm -f /app/stubs/.../logs/*
	if [[ $? -eq 0 ]]
	then
		echo "Delete logs"
	else
		echo "ERROR: log is not delete"
	fi
	
	echo "Statring service"
	/app/stubs/.../startup.sh
	
	fi 