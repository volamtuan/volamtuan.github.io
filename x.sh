#!/bin/bash

# Kiểm tra xem 3proxy có đang chạy hay không
if systemctl is-active --quiet 3proxy; then
    echo "Rotating proxies..."

    # Xoay IPv6 cho tất cả các cổng proxy
    awk -F "/" '{print $4}' /home/vlt/data.txt | while read port; do
        # Lấy địa chỉ IPv6 hiện tại của cổng
        current_ip=$(awk -v port="$port" -F "/" '$4 == port {print $5}' /home/vlt/data.txt)

        # Xóa IPv6 cũ
        ip -6 addr del "$current_ip/64" dev eth0 2>/dev/null

        # Tạo IPv6 mới
        new_ip=$(gen64 $(curl -6 -s icanhazip.com | cut -f1-4 -d':'))

        # Thêm IPv6 mới
        ip -6 addr add "$new_ip/64" dev eth0

        # Cập nhật thông tin trong file
        sed -i "s/$port\/$current_ip/$port\/$new_ip/" /home/vlt/data.txt
    done

    # Cập nhật cấu hình của 3proxy
    gen_3proxy > /usr/local/etc/3proxy/3proxy.cfg

    # Tải lại 3proxy mà không khởi động lại dịch vụ
    pkill -HUP 3proxy
    echo "Proxies rotated successfully."
else
    echo "3proxy is not running."
fi
