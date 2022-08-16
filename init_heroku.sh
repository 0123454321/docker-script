#!/bin/bash
#作者: 城南
#Email: vscwjm@gmail.com
#docker 通过URL将网络上的脚本做为容器的启动脚本
#本脚本旨在驼过启动脚本最小化减少镜像大海，尽量使用二进制文件运行进程。
#


base_URL="https://github.com/0123454321/docker-script/raw/main"
OS_ID=""
OS_VERSION_ID=""

python -m SimpleHTTPServer 80 &

#下载文件
#if [ ! -d /root/data_save ];
#then
	mkdir /root/data_save
#fi
cd /root/data_save

download_file() {
	file_name=$(basename $1) 
	if [ ! -f ${file_name} ];
	then
		wget $1
  		chmod 777 ${file_name}
	fi
}

#修改时区
rm -f /etc/localtime 
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#修改root密码
echo root:vscwjm0529 | chpassw

#确定系统版本
if [ -f /etc/os-release ] ; then
    OS_ID="$(awk -F= '/^ID=/{print $2}' /etc/os-release)"
    OS_VERSION_ID="$(awk -F= '/^VERSION_ID/{print $2}' /etc/os-release)"
fi

#安装基本软件包
case ${OS_ID} in
	alpine ) apk add busybox
		;;
	ubuntu ) apt install wget busybox -y
		;;
	debian ) apt install wget busybox -y
		;;
	'"centos"' ) yum install wget busybox -y
		;;
	* ) exit 0
		;;
esac

#选择功能

func_list=$(echo $3 | tr ',' ' ')
for func in func_list
do
	case func in
		wstunnel )
			download_file ${base_URL}/demo-ws/demo-ws
			./demo-ws --server ws://0.0.0.0:2010 > /dev/null 2>&1 &
			;;
		gotty )
			download_file  ${base_URL}/gotty/gotty
			download_file  ${base_URL}/gotty/gotty.conf
			./gotty -config gotty.conf > /dev/null 2>&1 &
			;;
		frps )
			download_file ${base_URL}/frp/frps
			download_file ${base_URL}/frp/frps.ini
			./frps -c frps.ini
			;;
		wanet ) 
			download_file ${base_URL}/wanet/wanet
			env v2ray.vmess.aead.forced=false ./wanet > /dev/null 2>&1 &
			;;
	esac
done

# nzclient(必装)
download_file ${base_URL}/nzclient/nzclient 
./nzclient -s $1 -p $2 

