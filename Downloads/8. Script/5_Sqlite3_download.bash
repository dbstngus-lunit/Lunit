#!/bin/bash

GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
WHITE="\003[0;38m"
COLOR_END="\033[0m"
NC="\033[0;0m"

#!/bin/bash

# 현재 디렉토리의 .deb 파일들을 찾아서 설치
for deb in ./*.deb; do
    echo -e "${YELLOW}Installing $deb...${NC}"
    sudo dpkg -i "$deb"
done

# 누락된 종속성이 있을 경우 설치
echo -e "${YELLOW}Checking for missing dependencies...${NC}"
sudo apt-get -f install

echo -e "${GREEN}Installation completed.${NC}"