#!/bin/bash
#作者: 城南
#Email: vscwjm@gmail.com
#docker 通过URL将网络上的脚本做为容器的启动脚本
#本脚本旨在驼过启动脚本最小化减少镜像大海，尽量使用二进制文件运行进程。
#


OS_ID=""
OS_VERSION_ID=""

#下载文件
cd /root/data_save

download_file() {
	file_name=$(basename $1) 
	if [ ! -f ${file_name} ];
	then
		wget $1
  		chmod a+x 
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
for func in $@
do
	case func in
		wstunnel )
			download_file 
			;;
		gotty ) echo .
			;;
		frps ) echo .
			;;
		nzclient ) echo .
			;;
		wanet ) echo .
			;;
		nginx ) echo .
			;;
		caddy ) echo .
			;;
	esac
done


