#!/bin/bash

# Tìm ID container của sing-box
CONTAINER_ID=$(docker ps -q --filter "name=xray")

# Kiểm tra xem container có đang chạy không
if [ -n "$CONTAINER_ID" ]; then
    echo "Restarting xray container..."
    docker restart $CONTAINER_ID
else
    echo "xray container is not running."
fi

# Thêm cron job nếu chưa tồn tại
(crontab -l | grep -q "restart_xray.sh") || (crontab -l; echo "0 */3 * * * $(realpath $0)") | crontab -
