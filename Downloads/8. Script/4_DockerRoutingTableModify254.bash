#!/bin/bash

# Modify Docker routing table script
# Change Lunit container comunication network setting to 254.~

# 색상 코드
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
WHITE="\033[0;38m"
NC="\033[0m"  # 종료 색상 코드

# 스크립트가 root 권한으로 실행되었는지 확인
if [ "$(id -u)" != "0" ]; then
   echo -e "${RED}이 스크립트는 root 권한으로 실행해야 합니다.${NC}" 1>&2
   exit 1
fi

# /etc/docker 디렉토리로 이동
cd /etc/docker

# daemon.json 파일 백업 (이미 존재하는 경우)
if [ -f "daemon.json" ]; then
    echo -e "${YELLOW}daemon.json 파일을 백업합니다. Path : cd/etc/docker${NC}"
    cp daemon.json daemon.json.backup
fi

# daemon.json 파일 생성/수정
cat > daemon.json <<EOF
{
    "data-root": "/home/docker",
    "bip": "254.254.0.1/24",
    "default-address-pools": [
        {"base":"254.254.0.0/16","size":24}
    ],
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
EOF

# Docker 데몬 설정 다시 불러오기 및 Docker 서비스 재시작
echo "Docker 데몬 설정을 다시 불러오고 Docker 서비스를 재시작합니다."
echo -e "${YELLOW}daemon reloading...${NC}"
systemctl daemon-reload
echo -e "${YELLOW}docker.service restating...${NC}"
systemctl restart docker.service

echo -e "${GREEN}스크립트 실행 완료.${NC}"

