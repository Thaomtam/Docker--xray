# Docker--xray
### HTTPUpgrade Headers

HTTPUpgrade được định cấu hình để xử lý nhiều loại nội dung khác nhau và tối ưu hóa hiệu suất kết nối. Các tiêu đề bao gồm:

- **Content-Type**: Chỉ định loại MIME mà máy chủ có thể gửi. Điêu nay bao gôm:
  - `application/octet-stream`
  - `video/mpeg`
  - `application/x-msdownload`
  - `text/html`
  - `application/x-shockwave-flash`
- **Độ dài nội dung**: Độ dài của nội dung cần gửi, được đặt thành `25000000` byte (25MB).
- **Mã hóa chuyển mã**: Cho biết nội dung được gửi theo khối.
- **Kết nối**: Đặt thành `keep-alive` để duy trì kết nối liên tục.
- **Thực dụng**: Đặt thành `no-cache` để đảm bảo phản hồi không được máy khách lưu vào bộ nhớ đệm.


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
                    "header": {
                        "type": "http",
                        "response": {
                            "version": "1.1",
                            "status": "200",
                            "reason": "OK",
                            "headers": {
                                "Content-Type": [
                                    "application/octet-stream",
                                    "video/mpeg",
                                    "application/x-msdownload",
                                    "text/html; charset=UTF-8",
                                    "application/x-shockwave-flash",
                                    "text/plain",
                                    "text/css",
                                    "text/javascript",
                                    "image/jpeg",
                                    "image/png",
                                    "audio/mpeg",
                                    "audio/ogg",
                                    "video/mp4",
                                    "application/json",
                                    "application/xml",
                                    "application/pdf",
                                    "application/zip",
                                    "application/x-www-form-urlencoded",
                                    "application/vnd.ms-excel",
                                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                    "multipart/form-data"
                                ],
                                "Content-Length": [
                                    "25000000"
                                ],
                                "Content-Encoding": [
                                    "gzip",
                                    "deflate"
                                ],
                                "Access-Control-Allow-Headers": [
                                    "Origin",
                                    "X-Requested-With",
                                    "Content-Type",
                                    "Accept",
                                    "Authorization"
                                ],
                                "Access-Control-Allow-Methods": [
                                    "GET",
                                    "POST",
                                    "PUT",
                                    "DELETE",
                                    "OPTIONS"
                                ],
                                "Access-Control-Allow-Origin": "*",
                                "Access-Control-Max-Age": "600",
                                "Access-Control-Request-Headers": [
                                    "Origin",
                                    "X-Requested-With",
                                    "Content-Type",
                                    "Accept",
                                    "Authorization"
                                ],
                                "Vary": "Accept-Encoding",
                                "Transfer-Encoding": [
                                    "chunked"
                                ],
                                "Connection": [
                                    "keep-alive"
                                ],
                                "Pragma": "no-cache"
                            }
                        }
                    },
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
    ghcr.io/xtls/xray-core:latest \
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
