#!/bin/bash 

# http://linuxforums.org.uk/index.php?topic=11261.0
# -------------------- install kernel headers to compile rtl8188eufw.bin ------------------
#echo "Remove '#' in /etc/apt/sources.list (for linux headers)"

apt-get update
apt-get install linux-headers-$(uname -r) git build-essential
# apt-get install linux-headers-686-pae build-essential linux-headers-generic git 


apt-get install hostapd
sudo service hostapd stop

# Compile new release of hostapd for rtl8188eu drivers
git clone https://github.com/lwfinger/rtl8188eu.git
cd rtl8188eu/hostapd-0.8/hostapd
cp defconfig .config
mv /usr/sbin/hostapd /usr/sbin/hostapd.bak
make
make install
cp hostapd /usr/sbin/hostapd
chmod 755 /usr/sbin/hostapd
cd -

cp /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf.bak

/bin/cat >> /etc/hostapd/hostapd.conf << hostapd_conf 
interface=wlan0
#driver=rtl871xdrv 
ssid=APAP
hw_mode=g
channel=11
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=AP_PASSWORD
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
macaddr_acl=0

hostapd_conf


# -------------------- comple Driver rtl8188eufw.bin ------------------
cd rtl8188eu/
make
# ls -la 8188eu.ko
# install -p -m 644 8188eu.ko  /lib/modules/3.18.0-kali3-686-pae/kernel/drivers/net/wireless
# or
make install 

# ----------- set default configuration location of the cofiguration file used by the daemon
echo DAEMON_CONF="/etc/hostapd/hostapd.conf" >> /etc/default/hostapd

echo "DONE"

echo "Modify you wifi encryption key in /etc/hostapd/hostapd.conf"
echo "REBOOT if needed and execute the folowing command to test the configuration file : "
echo "/usr/sbin/hostapd -dd /etc/hostapd/hostapd.conf"

# ok !
