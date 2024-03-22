#! /bin/bash

scenario=null

if [[ -z $1]]
then
	echo "Not found param for similation"
	exit
else
	scenario="Folder.Sceanrio.$1"
	echo "Scenario selected $Sceanrio"
fi

#Если не устанволены перменные окружения
#JAVA_HOME=/app/java/
#export JAVA_HOME
#export PATH=$JAVA_HOME/bin:$PATH
#GALTING_HOME=/app/Gatling
#export PATH=$GALTING_HOME/bin:$PATH

rm -r /app/nohip_log/*
nohup /app/Gatling/bin/gatling.sh -nr -s $scenario -rm local > /app/nohip_log/nohup.log >&1 &

if [[ $? -eq 0 ]]
then
	echo "INFO: Gatling RUN"
else
	echo "ERROR: Gatling not running"
fi

pid=`pgrep -f java`
echo "pid Gatling: $pid"

exit