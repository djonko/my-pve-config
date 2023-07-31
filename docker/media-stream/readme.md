# To add Jackett plugin check this link: # to enable jackett configure 
https://github.com/qbittorrent/search-plugins/wiki/How-to-configure-Jackett-plugin

# gluetun docker-compose env variable
```docker-compose 
VPN_SERVICE_PROVIDER="provider"
VPN_TYPE="wireguard"
WIREGUARD_PRIVATE_KEY="your provider private key"
WIREGUARD_ADDRESSES=10.14.0.2/16
SERVER_COUNTRIES="Canada,United States"
SERVER_HOSTNAMES=""
HTTPPROXY="on"
HTTPPROXY_USER=""
HTTPPROXY_PASSWORD=""
SHADOWSOCKS="on"
SHADOWSOCKS_LOG="on"
SHADOWSOCKS_CIPHER="aes-256-gcm"
FIREWALL_OUTBOUND_SUBNETS="192.168.20.0/24,192.168.161.0/24"
FIREWALL_DEBUG="on"
BLOCK_SURVEILLANCE="on"
```