#!/bin/sh
# Chạy root hoặc sudo

# 1. Cài SSH
if [ -f /etc/debian_version ]; then
    apt update && apt install -y openssh-server
elif [ -f /etc/redhat-release ]; then
    yum install -y openssh-server
fi

# 2. Kích hoạt password login và root login
sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config

# 3. Tạo key host nếu chưa có
ssh-keygen -A

# 4. Khởi chạy SSH daemon
if command -v systemctl >/dev/null 2>&1; then
    systemctl enable sshd
    systemctl restart sshd
else
    /usr/sbin/sshd -D &
fi

# 5. Firewall (CentOS 7)
if command -v firewall-cmd >/dev/null 2>&1; then
    firewall-cmd --permanent --add-service=ssh
    firewall-cmd --reload
fi

# 6. Kiểm tra cổng SSH
netstat -tlnp | grep 22

/usr/sbin/sshd && tail -f /dev/null

echo "SSH Ok"
