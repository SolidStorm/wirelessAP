#!/bin/bash

# dns/dhcp installation and startup with dnsmasq
### when hostapd is up and running let's install dns/dhcp

/bin/echo "Updating system and installing dhcp and Tor:"
apt-get install -y dnsmasq

/bin/echo "Configuring wlan0:"
/bin/cat >> /etc/network/interfaces << wlan_config 
## wlan0 static ip
auto wlan0
allow-hotplug wlan0
iface wlan0 inet static
address 192.168.0.1
netmask 255.255.255.0
wlan_config

sudo ifdown wlan0
sudo ifup wlan0

/bin/echo "Configuring dhcp:"
cp /etc/dnsmasq.conf /etc/dnsmasq.conf.bak
/bin/cat >> /etc/dnsmasq.conf << dnsmasq_config 
interface=wlan0
dhcp-range=wlan0,192.168.0.10,192.168.0.200,2h
dhcp-option=3,192.168.0.1 # router
dhcp-option=6,192.168.0.1 # DNS Server
dhcp-authoritative # force clients to grab a new IP
dnsmasq_config

ifup eth0
ifup wlan0

service dnsmasq start
/usr/sbin/update-rc.d dnsmasq enable

/bin/echo "DHCP/DNS up and running?"
service dnsmasq status

exit
