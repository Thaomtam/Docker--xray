## Docker link
```
https://hub.docker.com/r/thaomtam/xray
```
## Install Docker:
```
bash <(curl -sSL https://get.docker.com)
```
## Pull the image
```
docker pull thaomtam/xray
```
## Start a container
```
docker run -d -p443:443 -p80:80 -p16557:16557 -p8004:8004 -p8005:8005 --name xray --restart=always -v thaomtam/xray:latest
```
