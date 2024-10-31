#Если не устанволены перменные окружения
#JAVA_HOME=/app/java/
#export JAVA_HOME
#export PATH=$JAVA_HOME/bin:$PATH
#GALTING_HOME=/app/Gatling
#export PATH=$GALTING_HOME/bin:$PATH

#!/bin/bash

# Основная директория с папками сценариев
BASE_DIR="src/test/scala/simulations"

COLOR='\033[0;34m'
COLOR_G='\033[0;32m'
COLOR_R='\033[0;32m'
NC='\033[0m'


echo -e "${COLOR}------ Kill old Process ----${NC}"
PID_JAVA=($(pgrep -g java))
if [ ${#PID_JAVA[@]} -eq 0 ];
then
    echo "WARN: Not found Process"
else
    read -p "ERROR: Confirm kill Gatling process? (y/n)" answer
    if [[ $answer == [Yy] ]];
    then
        for pid in "${PID_JAVA[@]}"; do
        kill -9 $pid
        echo -e "WARN: Kill process ${COLOR_G} $pid ${NC}"
        done
    else
     echo "exit"
     exit 1
    fi
fi



# Проверяем наличие основной директории
if [ ! -d "$BASE_DIR" ]; then
  echo "Directory $BASE_DIR does not exist. Please check the path."
  exit 1
fi

# Ищем все поддиректории в основной директории
directories=($(find $BASE_DIR -mindepth 1 -maxdepth 1 -type d -exec basename {} \;))

# Проверяем наличие поддиректорий
if [ ${#directories[@]} -eq 0 ]; then
  echo "No directories found in $BASE_DIR."
  exit 1
fi

# Выводим список поддиректорий для выбора
echo -e "${COLOR} ---- List Directories ----- ${NC}"
for i in "${!directories[@]}"; do
  echo "$((i+1)). ${directories[$i]}"
done

# Dыбрать поддиректорию
read -p "Select directory: (1-${#directories[@]}): " dir_choice

# Получаем выбранную поддиректорию
selected_directory=${directories[$((dir_choice-1))]}

# Полный путь к выбранной поддиректории
SCENARIOS_DIR=$BASE_DIR/$selected_directory/

#Првоерка наличия директории
if [ ! -d "$SCEANRIO_DIR" ];
    then echo "ERROR: Directory $SCENARIOS_DIR does not exit."
    exit 1
fi

# Ищем все файлы Scala в выбранной поддиректории
scenarios=($(find $SCENARIOS_DIR -name "*.scala" -exec basename {} .scala \;))

# Проверяем наличие сценариев в выбранной поддиректории
if [ ${#scenarios[@]} -eq 0 ]; then
  echo "No scenarios found in $SCENARIOS_DIR."
  exit 1
fi

# Выводим список сценариев для выбора
echo -e "${COLOR} ---- List sceanrios $selected_directory ------ ${NC}"
for i in "${!scenarios[@]}"; do
  echo "$((i+1)). ${scenarios[$i]}"
done

# Просим пользователя выбрать сценарий
read -p "Select scenario: " choice


# Получаем выбранный сценарий
selected_scenario=${scenarios[$((choice-1))]}
echo "WARN: Path sceanrio: $SCEANRIO_DIR$selected_scenario"

path_scenario=$SCENARIOS_DIR$selected_scenario"
scenario=$(echo $path_scenario" | seq 's|.*/simulations/||' | sed 's|/|.|g')


echo -e "${COLOR} ---- Gatling process --- ${NC}"
echo -e "${COLOR_G} SCENARIO: ${scenario}${NC}"

nohup /app/Gatling/bin/gatling.sh -nr -s $scenario  -rm local > /app/nohup_log/nohup.log >&1 &

if [[ $? -eq 0 ]]
    then
        echo -e "${COLOR_G} GATLING RUN ${NC}"
    else
        echo "ERROR: Gatling not running"
fi

PID_JAVA=($(pgrep -f java))

echo "PID ${PID_JAVA[@]}"
echo "tail -f /app/nohup_log/nohup.log"
