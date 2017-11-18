#!/bin/bash

# Reminder
read -p "You're installing [ ss-redir for UBNT EdgeRouter ]. Confirm or hit Ctrl-C to exit."

# Init
dt=`date +%s`

# Install prerequisites
# sudo apt-get update
# sudo apt-get -y -qq install libev4 libsodium18 libmbedcrypto0 libc-ares2
dpkg -i assets/dependency_for_mips/*.deb

# Copy binary files
echo "Copying binary files..."
mkdir -p /config/ss/bin
chmod a+x bin/mips_cavium/ss-*
cp -rf bin/mips_cavium/* /config/ss/bin/

# Copy init scripts and config files
echo "Copying init scripts and config files..."
mkdir -p /config/ss/conf
if [ -f /config/ss/conf/config.json ]; then
    echo "Backing up old config file as config.json.backup_$dt"
    mv /config/ss/conf/config.json /config/ss/conf/config.json.backup_$dt
fi
cp -Prvf assets /config/ss/
cp -rf assets/ss-redir/etc/default/shadowsocks-libev /etc/default/shadowsocks-libev
cp -rf assets/ss-redir/etc/shadowsocks-libev/config.json /config/ss/conf/config.json
cp -rf assets/ss-redir/etc/shadowsocks-libev/acl.acl /config/ss/conf/acl.acl
chmod a+x assets/ss-redir/etc/init.d/shadowsocks-libev
cp -rf assets/ss-redir/etc/init.d/shadowsocks-libev /etc/init.d/shadowsocks-libev
cp -rf assets/ss-redir/pdnsd.conf /config/ss/conf/pdnsd.conf
cp -rf assets/ss-redir/chnroute.txt /config/ss/conf/chnroute.txt
update-rc.d shadowsocks-libev defaults 99
echo "*/5 * * * * root bash /config/ss/bin/ss-monitor.sh" > /etc/cron.d/ss-monitor
echo "Please fill up ports and passwords by yourself."
echo "Use [ /etc/init.d/shadowsocks-libev start ] to start service."
