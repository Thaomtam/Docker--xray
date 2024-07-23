# Docker-Sing-Box
*** TÂM ĐẮC NHẤT TỚI GIỜ [>3<]
## CẤU HÌNH MÚI GIỜ
```
timedatectl set-timezone Asia/Ho_Chi_Minh
```
## CÀI Docker:
```
bash <(curl -sSL https://get.docker.com)
```
## thoitiet.json
```
{
    "log": {
        "loglevel": "warning"
    },
    "routing": {
        "rules": [
            {
                "port": "443",
                "network": "udp",
                "outboundTag": "block"
            }
        ]
    },
    "inbounds": [
        {
            "port": 80,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "thoitiet"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "httpupgradeSettings": {
                    "headers": {},
                    "host": "",
                    "path": "/"
                },
                "network": "httpupgrade",
                "security": "none"
            }
        },
        {
            "port": 16557,
            "protocol": "socks",
            "settings": {
                "auth": "password",
                "accounts": [
                    {
                        "user": "thoitiet",
                        "pass": "thoitiet"
                    }
                ],
                "udp": true,
                "ip": "127.0.0.1"
            },
            "streamSettings": {
                "network": "tcp",
                "security": "none"
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom",
            "tag": "direct"
        },
        {
            "protocol": "blackhole",
            "tag": "block"
        }
    ]
}
```
## KHỞI ĐỘNG 
```
docker run -itd \
    -e XRAY_VMESS_AEAD_FORCED=false \
    -v ./config.json:/etc/xray/config.json \
    --network=host \
    --dns 8.8.8.8 \
    --dns 8.8.4.4 \
    --env TZ=Asia/Ho_Chi_Minh \
    --name=xray \
    --restart=unless-stopped \
    ghcr.io/xtls/xray-core \
    -c /etc/xray/config.json
```
## Check logs
```
docker logs -f xray
```
## Làm mới
```
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
```
## Hạt nhân tuỳ chỉnh tcp xoá kernel
```
bash -c "$(curl -L https://raw.githubusercontent.com/ylx2016/Linux-NetSpeed/master/tcp.sh)"
```
## Hạt nhân tuỳ chỉnh tcp không xoá kernel
```
bash -c "$(curl -L https://raw.githubusercontent.com/ylx2016/Linux-NetSpeed/master/tcpx.sh)"
```
## Xử lý vấn đề không thể truy cập lưu lượng truy cập trực tiếp của DAE trong một số môi trường mạng nhất định
```
sudo iptables -P FORWARD DROP
sudo iptables -A FORWARD -p tcp --dport 443 -j ACCEPT
sudo iptables -A FORWARD -p udp --dport 443 -j ACCEPT
sudo iptables -A FORWARD -p tcp --dport 80 -j ACCEPT
sudo iptables -A FORWARD -p udp --dport 80 -j ACCEPT
```
## HOẶC
```
sudo iptables -P FORWARD ACCEPT
```
## HOÀN NGUYÊN 
```
sudo iptables -P FORWARD DROP
```
## XOÁ frontend
```
sudo kill -9 3188
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/lib/dpkg/lock
sudo dpkg --configure -a
```
## XỬ LÝ TRÀN BỘ NHỚ
```
bash -c "$(curl -L https://raw.githubusercontent.com/Thaomtam/Docker--xray/main/restart_xray.sh)"
```
