


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

