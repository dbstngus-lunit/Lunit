#!/bin/bash

# Time Zone Modify Script


GW=($(docker ps --format "{{.Names}}" | grep 'dicom.*gateway.*app'))

echo "Please select the timezone by entering the corresponding number:"
echo "1) Asia/Seoul"
echo "2) Asia/Singapore"
echo "3) Asia/Manila"
echo "4) Asia/Bangkok"
echo "5) Asia/Tokyo"
echo "6) Asia/Jakarta"
echo "7) America/Los_Angeles"
echo "8) Asia/Shanghai"
echo "9) Asia/Kolkata"
echo "10) Australia/Sydney"

read -p "Enter your choice (1-10): " choice

case $choice in
    1) timezone="Asia/Seoul";;
    2) timezone="Asia/Singapore";;
    3) timezone="Asia/Manila";;
    4) timezone="Asia/Bangkok";;
    5) timezone="Asia/Tokyo";;
    6) timezone="Asia/Jakarta";;
    7) timezone="America/Los_Angeles";;
    8) timezone="Asia/Shanghai";;
    9) timezone="Asia/Kolkata";;
    10) timezone="Australia/Sydney";;
    *) echo "Invalid choice, exiting."; exit 1;;
esac

# GW 배열을 순회하며 각 컨테이너에 대한 타임존 설정 변경
for gw_name in "${GW[@]}"; do
    GW_conf=$(docker inspect -f '{{range .Mounts}}{{.Source}}{{print "\n"}}{{end}}' "$gw_name" | grep env | xargs -L 1 dirname)
    GW_ENV="$GW_conf/.env"

    if [ -f "${GW_ENV}" ]; then
        sed -i "s%TIMEZONE=.*%TIMEZONE=$timezone%" "${GW_ENV}"
        echo "Timezone updated to $timezone in ${GW_ENV}."
    else
        echo "Error: File ${GW_ENV} does not exist for container $gw_name."
    fi
done