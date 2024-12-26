
#!/bin/bash



# URL kiểm tra IP

TEST_URL="http://httpbin.org/ip"

IP_INFO_API="https://ipinfo.io"  # Dịch vụ để lấy thông tin quốc gia

LOG_FILE="proxy_check.log"



# Tạo hoặc xóa log cũ

echo "Bắt đầu kiểm tra proxy..." > $LOG_FILE


OPEN_PORTS=$(netstat -tuln | grep LISTEN | awk '{print $4}' | grep -oE '[0-9]+$' | sort -u)



if [[ -z "$OPEN_PORTS" ]]; then

    echo "Không tìm thấy cổng nào đang mở."

    echo "Không tìm thấy cổng nào đang mở." >> $LOG_FILE

    exit 1

fi



echo "Danh sách cổng đang mở: $OPEN_PORTS"

echo "Danh sách cổng đang mở: $OPEN_PORTS" >> $LOG_FILE

echo "Bắt đầu kiểm tra các proxy..." >> $LOG_FILE



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



echo "Hoàn tất kiểm tra."

echo "Hoàn tất kiểm tra." >> $LOG_FILE
