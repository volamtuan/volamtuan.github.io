import requests
from concurrent.futures import ThreadPoolExecutor, as_completed
import threading
import random
from colorama import Fore, Style

# Dải cổng và danh sách các địa chỉ IP proxy cho socks5
proxy_ports = list(range(10000, 50000))
proxy_ips = ["localhost"]

# Biến đếm tổng số email, email có liên kết và không có liên kết
total_emails = 0
linked_count = 0
not_linked_count = 0

# Danh sách email có liên kết và không có liên kết để hiển thị cuối cùng
linked_emails = []
not_linked_emails = []
failed_emails = []  # Danh sách cho các email không thể kiểm tra

# Sử dụng khóa để tránh xung đột khi cập nhật biến đếm
lock = threading.Lock()

# Hàm tạo User-Agent ngẫu nhiên
def get_random_user_agent():
    user_agents = [
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Safari/605.1.15",
        "Mozilla/5.0 (Linux; Android 10; Pixel 3 XL Build/QQ1A.200205.002) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Mobile Safari/537.36",
        "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1",
        "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
    ]
    return random.choice(user_agents)

# Hàm ghi log vào file
def write_to_file(filename, content):
    with open(filename, "a") as file:
        file.write(content + "\n")

# Hàm kiểm tra email qua API
def check_email(email):
    global linked_count, not_linked_count
    url = f'https://b-graph.facebook.com/recover_accounts?q=&friend_name=&qs=%7B"email":["{email}"]%7D&summary=true&device_id=6c7da20a-466f-4912-a5fe-0e0ca805dd9d&src=fb4a_login_openid_as&machine_id=128-YiSyRRfDZSNMYar9Ks2d&sfdid=2e0f71a2-9470-42bb-a906-b03182802ccf&fdid=6c7da20a-466f-4912-a5fe-0e0ca805dd9d&sim_serials=[]&sms_retriever=false&cds_experiment_group=-1&shared_phone_test_group=&allowlist_email_exp_name=&shared_phone_exp_name=&shared_phone_cp_nonce_code=&shared_phone_number=&is_auto_search=true&is_feo2_api_level_enabled=false&is_sso_like_oauth_search=false&openid_tokens=["eyJhbGciOiJSUzI1NiIsImtpZCI6IjU4YjQyOTY2MmRiMDc4NmYyZWZlZmUxM2MxZWIxMmEyOGRjNDQyZDAiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwiYXpwIjoiMTUwNTc4MTQzNTQtbWthcmtndGlscTdrNWJvN2Y1ODA0azFkZTAybTNzYjYuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIxNTA1NzgxNDM1NC04MGNnMDU5Y240OWo2a21oaGtqYW00YjAwb24xZ2Iybi5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsInN1YiI6IjEwNzM2NDU2NzI3OTYyMTM1MTQ1OCIsImVtYWlsIjoibmQ1MDM2NzI4QGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJpYXQiOjE2NDgyNTk4NDEsImV4cCI6MTY0ODI2MzQ0MX0.W8XLp7y7KZVMtPF60XfePG5p9byXFnLYH668bqht-cgyFAn_qZzKN329dOzwuVH6rkuTCClQe_VpmGGuCIGNiBnXIJ8CBhuPrzx9PykD9wVJ3qebtjBalbMuKR1BhR7FGwcNl1JAf1K1HdVgXquj0-nnRScPYRrgTyTOoUyToUapGnY-QQbH2dI1012K5Kw_edt5woJoY3kic8b5-AKImt1hmgwmrxhEhK5XSmqhOQ0ISJH7ZFhLF-agpSRppJ1EtwXQ9CFojzBSjiP6LsaIHpsy-vMyA27tUbhR88IggzFsIo1qbi2Tr-PqwddEcPb3tZjo52uFRq9jD3Icw558pw"]&encrypted_msisdn=&locale=vi_VN&client_country_code=VN&method=GET&fb_api_req_friendly_name=accountRecoverySearch&fb_api_caller_class=AccountSearchHelper&access_token=350685531728%7C62f8ce9f74b12f84c123cc23437a4a32'
    headers = {"User-Agent": get_random_user_agent()}

    for attempt in range(3):  # Thử tối đa 3 lần
        ip = random.choice(proxy_ips)
        port = random.choice(proxy_ports)
        proxy = f"socks5://{ip}:{port}"
        proxies = {"http": proxy, "https": proxy}

        try:
            response = requests.get(url, headers=headers, proxies=proxies, timeout=10)
            if response.status_code == 200:
                data = response.json()
                with lock:
                    if 'summary' in data and data['summary'].get('total_count', 0) == 1:
                        linked_count += 1
                        linked_emails.append(email)
                        write_to_file("linked_emails.txt", email)
                        return f"{Fore.GREEN}{email} có liên kết với Facebook{Style.RESET_ALL}"
                    else:
                        not_linked_count += 1
                        not_linked_emails.append(email)
                        write_to_file("not_linked_emails.txt", email)
                        return f"{Fore.RED}{email} không có liên kết với Facebook{Style.RESET_ALL}"
            else:
                write_to_file("log.txt", f"Lỗi: {response.status_code} cho email {email} với proxy {proxy}")
                print(f"Lỗi: {response.status_code} với proxy {proxy}, đang thử lại...")
        except requests.RequestException:
            print(f"Lỗi proxy {proxy}, thử lại với proxy khác...")

    # Nếu tất cả các lần thử đều không thành công
