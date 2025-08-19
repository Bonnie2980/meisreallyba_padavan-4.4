#!/bin/sh
#nvram set ntp_ready=0

mkdir -p /tmp/dnsmasq.dom
logger -t "为防止dnsmasq启动失败，创建/tmp/dnsmasq.dom/"

logger -t "自动启动" "正在检查路由是否已连接互联网！"
count=0
while :
do
	ping -c 1 -W 1 -q 223.5.5.5 1>/dev/null 2>&1
	if [ "$?" == "0" ]; then
		break
	fi
	sleep 5
	ping -c 1 -W 1 -q baidu.com 1>/dev/null 2>&1
	if [ "$?" == "0" ]; then
		break
	fi
	sleep 5
	count=$((count+1))
	if [ $count -gt 18 ]; then
		break
	fi
done

if [ $(nvram get pppoemwan_enable) = 1 ] ; then
sleep 20
fi

if [ $(nvram get aliddns_enable) = 1 ] ; then
logger -t "自动启动" "正在启动阿里ddns"
/usr/bin/aliddns.sh start
fi

if [ $(nvram get ss_enable) = 1 ] ; then
logger -t "自动启动" "正在启动科学上网"
/usr/bin/shadowsocks.sh start
fi

if [ $(nvram get aliyundrive_enable) = 1 ] ; then
logger -t "自动启动" "正在启动阿里云盘"
/usr/bin/aliyundrive-webdav.sh start
fi

if [ $(nvram get sqm_enable) = 1 ] ; then
sleep 30
logger -t "自动启动" "正在启动SQM QOS"
/usr/lib/sqm/run.sh
fi

if [ $(nvram get frpc_enable) = 1 ] ; then
logger -t "自动启动" "正在启动frp client"
/usr/bin/frp.sh start
fi
