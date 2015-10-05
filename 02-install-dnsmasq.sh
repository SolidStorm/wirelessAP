# install dnsmasq : 
# default router and dns (this machine as host ap): 192.168.150.1/24
# dhcp offer range : 192.168.150.2-10
# dns server : 

apt-get install dnsmasq
service dnsmasq stop
sudo update-rc.d dnsmasq disable

cp dnsmasq.conf /etc/dnsmasq.conf
# example configuration
# Bind to only one interface
# bind-interfaces
# Choose interface for binding
# interface=wlan0
# Specify range of IP addresses for DHCP leasses
# dhcp-range=192.168.150.2,192.168.150.10

# Configure IP address for WLAN
sudo ifconfig wlan0 192.168.150.1
