#!/bin/sh

kmsenable=`nvram get kms_enable`
if [ "$kmsenable" != 1 -a -n "`pidof vlmcsd`" ]; then
 killall vlmcsd 
 sed -Ei '/_vlmcs._tcp/d' /etc/storage/dnsmasq/dnsmasq.conf; restart_dhcpd;
 sed -i '/kms/d' /etc/storage/post_wan_script.sh
 logger -t "KMS" "已关闭。" 
 exit 0
fi

if [ "$kmsenable" != 1 ]; then
logger -t "KMS" "未开启" 
exit 0
fi
#port="1688"
if [ ! -f /etc_ro/vlmcsd.kmd ]; then
/etc/storage/vlmcsd&
fi
if [ -f /etc_ro/vlmcsd.kmd ]; then
/etc/storage/vlmcsd -j /etc_ro/vlmcsd.kmd &
fi
computer_name=`nvram get computer_name`
sed -Ei '/_vlmcs._tcp/d' /etc/storage/dnsmasq/dnsmasq.conf
nvram set lan_domain="lan"
echo "srv-host=_vlmcs._tcp.lan,$computer_name.lan,1688,0,100" >> /etc/storage/dnsmasq/dnsmasq.conf
restart_dhcpd
sleep 2
if [ ! -z "$(ps - w | grep "vlmcsd" | grep -v grep )" ]; then
logger -t "kms" "启动成功"
sed -i '/kms/d' /etc/storage/post_wan_script.sh
cat >> /etc/storage/post_wan_script.sh << EOF
/usr/bin/kms.sh&
EOF
fi
[ -z "$(ps - w | grep "vlmcsd" | grep -v grep )" ] && logger -t "kms" "启动失败, 注意检查端口是否有冲突" && nvram set kms_enable="0"
