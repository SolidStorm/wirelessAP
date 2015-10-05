# Start DHCP/DNS server
sudo service dnsmasq restart
service hostapd restart

# Enable routing to eth0
sudo sysctl net.ipv4.ip_forward=1
# Enable NAT
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
