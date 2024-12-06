sudo rm -f /etc/netplan/01-netcfg.yaml

sudo bash -c 'cat > /etc/netplan/01-netcfg.yaml <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    ens5:
      addresses:
        - 172.31.27.38/20             # IPv4 Address
        - 2600:1f18:5bb3:6300::1/56  # IPv6 Address 1
        - 2600:1f18:5bb3:6300::2/56  # IPv6 Address 2
        - 2600:1f18:5bb3:6300::3/56  # IPv6 Address 3
        - 2600:1f18:5bb3:6300::4/56  # IPv6 Address 4
      gateway4: 172.31.16.1           # IPv4 Gateway
      gateway6: 2600:1f18:5bb3:6300::1 # IPv6 Gateway
      nameservers:
        addresses:
          - 8.8.8.8                  # IPv4 DNS
          - 8.8.4.4                  # IPv4 DNS
          - 2600:1f18:5bb3:6300::1   # IPv6 DNS
EOF

sudo netplan apply
sudo apt update && sudo apt install -y squid

sudo tee /etc/squid/squid.conf << EOF
# Cấu hình Squid lắng nghe trên cổng 3128
http_port 3128

# Định nghĩa các địa chỉ IPv6 để xoay vòng
tcp_outgoing_address 2600:1f18:5bb3:6300::1
tcp_outgoing_address 2600:1f18:5bb3:6300::2
tcp_outgoing_address 2600:1f18:5bb3:6300::3
tcp_outgoing_address 2600:1f18:5bb3:6300::4

# Cấp quyền truy cập cho tất cả các kết nối
acl all src all
http_access allow all
EOF

# Khởi động lại dịch vụ Squid
sudo systemctl restart squid

# Cho phép cổng 3128 trên tường lửa
sudo ufw allow 3128/tcp
sudo ufw reload
sudo netstat -tuln | grep 3128
