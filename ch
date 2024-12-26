
#!/bin/bash
sudo apt install net-tools -y
sudo apt update && sudo apt full-upgrade -y
sudo fallocate -l 4G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile && echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
# URL kiểm tra IP

TEST_URL="http://httpbin.org/ip"
IP_INFO_API="https://ipinfo.io"  # Dịch vụ để lấy thông tin quốc gia
LOG_FILE="proxy_check.log"

# Kiểm tra jq có sẵn không
if ! command -v jq &> /dev/null; then
    echo "Lỗi: jq không được cài đặt. Vui lòng cài đặt jq để script hoạt động chính xác."
    exit 1
fi

# Tạo hoặc xóa log cũ
echo "Bắt đầu kiểm tra proxy vào $(date)" > $LOG_FILE

# Lấy danh sách cổng đang mở và kiểm tra tất cả các cổng lắng nghe
OPEN_PORTS=$(netstat -tuln | grep LISTEN | awk '{print $4}' | grep -oE '[0-9]+$' | sort -u)

if [[ -z "$OPEN_PORTS" ]]; then
    echo "Không tìm thấy cổng nào đang mở." | tee -a $LOG_FILE
    exit 1
fi

echo "Danh sách cổng đang mở: $OPEN_PORTS" | tee -a $LOG_FILE
echo "Bắt đầu kiểm tra các proxy..." | tee -a $LOG_FILE

# Duyệt qua từng cổng trong danh sách mở
for PORT in $OPEN_PORTS; do
    echo -n "Đang kiểm tra cổng $PORT... "
    echo -n "Đang kiểm tra cổng $PORT... " >> $LOG_FILE

    # Kiểm tra proxy với cổng đã chọn
    OUTPUT=$(curl -s -x "http://localhost:$PORT" $TEST_URL | jq -r '.origin' 2>/dev/null)
    
    if [[ $? -eq 0 && -n "$OUTPUT" ]]; then
        # Lấy thông tin quốc gia từ IP của proxy
        COUNTRY=$(curl -s "$IP_INFO_API/$OUTPUT" | jq -r '.country' 2>/dev/null)
        
        if [[ -z "$COUNTRY" || "$COUNTRY" == "null" ]]; then
            COUNTRY="Không xác định"
        fi

        echo "OK - IP: $OUTPUT, Quốc gia: $COUNTRY"
        echo "OK - IP: $OUTPUT, Quốc gia: $COUNTRY" >> $LOG_FILE
    else
        echo "Không hoạt động"
        echo "Không hoạt động" >> $LOG_FILE
    fi
done

echo "Hoàn tất kiểm tra vào $(date)." | tee -a $LOG_FILE
