#!/bin/bash

log_file="proxy_check.log"
echo "🔍 Bắt đầu kiểm tra proxy trên tất cả các cổng đang mở..." | tee -a "$log_file"

for port in $(netstat -tuln | awk '/LISTEN/ {print $4}' | grep -oE '[0-9]+$' | sort -u); do
    proxy="localhost:$port"
    echo "🔄 Kiểm tra Cổng: $port..." | tee -a "$log_file"
    
    # Lấy IP qua proxy
    ip_json=$(curl -s --max-time 3 --proxy "http://$proxy" "https://httpbin.org/ip")

    if [ $? -ne 0 ] || [ -z "$ip_json" ]; then
        echo -e "\033[31m❌ Cổng: $port | Không lấy được IP\033[0m" | tee -a "$log_file"
        continue
    fi

    # Trích xuất địa chỉ IP từ JSON
    origin_ip=$(echo "$ip_json" | jq -r '.origin' 2>/dev/null)

    if [ -z "$origin_ip" ] || [ "$origin_ip" == "null" ]; then
        echo -e "\033[31m❌ Cổng: $port | Không trích xuất được IP\033[0m" | tee -a "$log_file"
        continue
    fi

    # Lấy quốc gia từ IP
    country_json=$(curl -s --max-time 3 "http://ip-api.com/json/$origin_ip")
    country=$(echo "$country_json" | jq -r '.country' 2>/dev/null)

    if [ -z "$country" ] || [ "$country" == "null" ]; then
        echo -e "\033[33m⚠️ Cổng: $port | IP: $origin_ip | Không lấy được quốc gia\033[0m" | tee -a "$log_file"
    else
        echo -e "\033[32m✅ Cổng: $port | IP: $origin_ip | Quốc gia: $country\033[0m" | tee -a "$log_file"
    fi
done

echo "✅ Hoàn tất kiểm tra proxy! Log đã được lưu tại: $log_file"
