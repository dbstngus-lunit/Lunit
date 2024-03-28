#!/bin/bash

# Docker Imager Upload Script
# 스크립트 경로에 있는 .tar / .tar.gz image 업로드

GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
WHITE="\003[0;38m"
COLOR_END="\033[0m"
NC="\033[0;0m"

#-------------------------------------------------------------------------------------------

# # 툴킷 설치
# echo -e "${YELLOW}Toolkit Install${NC}"
# sudo chmod 777 ./lunit-toolkit_2.1.2.deb
# sudo dpkg -i ./lunit-toolkit_2.1.2.deb


DIRECTORY="."
# check path
if [ -d "$DIRECTORY" ]; then
    echo "Directory exists: $DIRECTORY"
    IMAGE_DIR=$DIRECTORY
    # .tar image file에 대한 로드
    if ls "$DIRECTORY"/*.tar 1> /dev/null 2>&1; then
        echo "There are .tar files in $DIRECTORY"
        # IMAGE_DIR 디렉토리에서 .tar 파일을 찾아서 각각 로드
        for image_file in ${IMAGE_DIR}/*.tar; do
            echo "Loading image: ${image_file}"
            docker load -i "${image_file}"
        done

        echo -e "${GREEN}All images loaded successfully.${COLOR_END}"
    else
        echo "${RED}No .tar files found in $DIRECTORY${NC}"
    fi
    # .tar.gz image file에 대한 로드
    if ls "$DIRECTORY"/*.tar.gz 1> /dev/null 2>&1; then
        echo "There are .tar.gz files in $DIRECTORY"
        # IMAGE_DIR 디렉토리에서 .tar 파일을 찾아서 각각 로드
        for image_file in ${IMAGE_DIR}/*.tar.gz; do
            echo "Loading image: ${image_file}"
            docker load -i "${image_file}"
        done

        echo -e "${GREEN}All images loaded successfully.${COLOR_END}"
    else
        echo "${RED}No .tar.gz files found in $DIRECTORY${NC}"
    fi

else
    echo "Directory does not exist: $DIRECTORY. Creating now..."
    mkdir -p "$DIRECTORY"
    echo "Directory created: $DIRECTORY"
    echo -e "${YELLOW}Please move the image you want to load to the “$DIRECTORY” path. and re-execute command. ${COLOR_END}"
fi


#conf file을 기존 툴킷폴더에 있는거랑 교체 
# sudo mkdir /usr/share/lunit-toolkit/toolkit/misc/
# sudo cp -r ./conf /usr/share/lunit-toolkit/toolkit/misc/
# echo -e "${GREEN}Replased conf master !!${NC}"


#replaced scripts
# sudo cp ./ConfHandling.bash /usr/share/lunit-toolkit/toolkit/subscripts/ConfHandling.bash
# sudo cp ./GenerateAWSLinks.ps1 /usr/share/lunit-toolkit/toolkit/subscripts/GenerateAWSLinks.ps1
# sudo cp ./AutoUpdate.bash /usr/share/lunit-toolkit/toolkit/AutoUpdate.bash
# echo -e "${GREEN}Replaced toolkit scripts !! ${NC}"

echo -e "${GREEN} Docker Image upload completed. ${NC}"

