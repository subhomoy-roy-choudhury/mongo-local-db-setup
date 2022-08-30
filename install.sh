#!/bin/bash

DATABASE_DUMP_FOLDER_NAME="database";
DATABASE_ZIP_FOLDER="db_zip";
ENV_FILE_NAME="local.env";
UNAMESTR=$(uname)

DEFAULT_MONGO_VERSION=4.2.2;
DEFAULT_CONTAINER_NAME=local-mongo

#Finding Colors
COLORS_FILE_PATH='./utils/find-colors.sh'

COLOR_OFF=$(source $COLORS_FILE_PATH Color_Off);
GREEN=$(source $COLORS_FILE_PATH Green);
RED=$(source $COLORS_FILE_PATH Red);

echo -e "${GREEN}[+] Creating database folder${COLOR_OFF}";      # printf is also used instead of echo -e

{
mkdir $DATABASE_ZIP_FOLDER
mkdir $DATABASE_DUMP_FOLDER_NAME
} &> /dev/null   # hide stderr and stdout output using /dev/null

echo -e "${GREEN}[+] Checking for local.env file${COLOR_OFF} "

FILE=local.env
if [ -f "$FILE" ]; then
    echo -e "${RED}[+] $FILE exists.${COLOR_OFF}"
else 
    echo -e "${GREEN}[+] Creating $FILE${COLOR_OFF}"

    read -p "Enter the MongoDB version [$DEFAULT_MONGO_VERSION]: " MONGO_VERSION;
    echo "MONGO_VERSION=${MONGO_VERSION:-$DEFAULT_MONGO_VERSION}" > $FILE

    read -p "Enter the Container Name [$DEFAULT_CONTAINER_NAME]: " CONTAINER_NAME;
    echo "CONTAINER_NAME=${CONTAINER_NAME:-$DEFAULT_CONTAINER_NAME}" >> $FILE
fi

echo "[+] Loading Environment variables"

if [ "$UNAMESTR" = 'Linux' ]; then

  export $(grep -v '^#' $ENV_FILE_NAME | xargs -d '\n')

elif [ "$UNAMESTR" = 'FreeBSD' ] || [ "$UNAMESTR" = 'Darwin' ]; then

  export $(grep -v '^#' $ENV_FILE_NAME | xargs -0)

fi

echo "[+] Building and starting mongo:4.2.2 instance"
docker-compose up --build -d

echo "[+] Finished"