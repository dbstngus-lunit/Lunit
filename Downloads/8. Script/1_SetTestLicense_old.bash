#!/bin/bash

# 사내 TEST 라이센스 적용 script

# 색상 코드
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
WHITE="\033[0;38m"
NC="\033[0m"  # 종료 색상 코드

# hasp.ini에 저장할 내용
hasp_test="[REMOTE]
broadcastsearch = 0
aggressive = 1
serversearchinterval = 30
serveraddr = 10.120.100.1"

# Docker 컴포즈 재시작 함수
LicenseApply() {
    echo -e "${YELLOW}hasp.ini 생성${NC}"
    echo "$hasp_test" > ./hasp.ini
    echo "-----------------------------------"

    echo -e "${YELLOW}docker-compose.yml 수정${NC}"
    sed -i '/logrotated.conf.template/a \
    \  - ./hasp.ini:/root/.hasplm/hasp_107074.ini' docker-compose.yml
    echo "-----------------------------------"

    echo -e "${YELLOW}docker sleep...${NC}"
    sudo docker-compose down
    echo "-----------------------------------"

    echo -e "${YELLOW}docker wake up...${NC}"
    sudo docker-compose up -d
}

# 입력 횟수 카운터
attempt=0

# 사용자 입력 반복
while true; do
  echo -e "${YELLOW}Please enter your choice (cxr/mmg):${NC}"
  read choice
  
  if [[ "$choice" == "cxr" || "$choice" == "mmg" ]]; then
    TARGET_DIR="/opt/lunit/conf/insight-inference-server-$choice"
    if [ ! -d "$TARGET_DIR" ]; then
      echo -e "${RED}$TARGET_DIR 경로가 존재하지 않습니다.${NC}"
      exit 1
    fi
    break
  else
    echo -e "${RED}Invalid input. Please enter 'cxr' or 'mmg'${NC}"
    attempt=$((attempt + 1))
    if [ $attempt -ge 2 ]; then
      echo -e "${RED}Maximum attempt limit reached. Exiting.${NC}"
      exit 1
    fi
  fi
done

# 선택된 경로에서 명령 실행
echo "Executing command for $choice..."
echo -e "작업 디렉토리: ${GREEN}$TARGET_DIR${NC} /n"
cd "$TARGET_DIR"
LicenseApply