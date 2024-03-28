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

    # TARGET_DIR 값에 따른 조건부 sed 명령 실행
    if [[ "$TARGET_DIR" == "/opt/lunit/conf/insight-inference-server-cxr" ]]; then
        echo -e "${YELLOW}docker-compose.yml 수정${NC}"
        sed -i '/logrotated.conf.template/a \
      \- ./hasp.ini:/root/.hasplm/hasp_107074.ini' docker-compose.yml
    elif [[ "$TARGET_DIR" == "/opt/lunit/conf/insight-cxr/insight-cxr-inference" ]]; then
        echo -e "${YELLOW}CXR3170 docker-compose.yml 수정${NC}"
        sed -i '/insight-inference-service/a \
      \- ./hasp.ini:/root/.hasplm/hasp_107074.ini' docker-compose.yml
    elif [[ "$TARGET_DIR" == "/opt/lunit/conf/insight-inference-server-mmg" ]]; then
        echo -e "${YELLOW}docker-compose.yml 수정${NC}"
        sed -i '/logrotated.conf.template/a \
      \- ./hasp.ini:/root/.hasplm/hasp_107074.ini' docker-compose.yml
  
    fi
    echo "-----------------------------------"
    echo -e "${YELLOW}docker sleep...${NC}"
    sudo docker-compose down
    echo "-----------------------------------"

    echo -e "${YELLOW}docker wake up...${NC}"
    sudo docker-compose up -d
}

# 입력 횟수 카운터
attempt=0

while true; do
  echo -e "${YELLOW}Please select an option:${NC}"
  echo -e "1. CXR"
  echo -e "2. MMG"
  echo -e "3. CXR 3170"
  read choice
  
  case $choice in
    1)
      TARGET_DIR="/opt/lunit/conf/insight-inference-server-cxr"
      ;;
    2)
      TARGET_DIR="/opt/lunit/conf/insight-inference-server-mmg"
      ;;
    3)
      TARGET_DIR="/opt/lunit/conf/insight-cxr/insight-cxr-inference"
      ;;
    *)
      echo -e "${RED}Invalid input. Please enter '1', '2', or '3'${NC}"
      attempt=$((attempt + 1))
      if [ $attempt -ge 2 ]; then
        echo -e "${RED}Maximum attempt limit reached. Exiting.${NC}"
        exit 1
      fi
      continue
      ;;
  esac

  if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}$TARGET_DIR 경로가 존재하지 않습니다.${NC}"
    exit 1
  fi
  break
done

echo -e "Selected directory: ${GREEN}$TARGET_DIR${NC}"
cd "$TARGET_DIR"
LicenseApply