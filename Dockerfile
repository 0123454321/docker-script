FROM alpine
EXPOSE 80
CMD  apk update && apk add curl nginx bash && bash <(curl -Lso- https://raw.githubusercontent.com/0123454321/docker-script/main/init.sh) status.wangjm.ml:7777 fly001