<?php
header('Content-Type: application/json');

// Nhận dữ liệu từ yêu cầu POST
$input = json_decode(file_get_contents('php://input'), true);
if (!isset($input['proxy']) || empty(trim($input['proxy']))) {
    echo json_encode(['error' => 'Proxy không hợp lệ']);
    exit;
}

$proxy = trim($input['proxy']);
$proxyParts = explode(":", $proxy);

if (count($proxyParts) != 2 && count($proxyParts) != 4) {
    echo json_encode(['error' => 'Proxy không hợp lệ']);
    exit;
}

// Kiểm tra nếu có xác thực
if (count($proxyParts) == 4) {
    $host = $proxyParts[0];
    $port = $proxyParts[1];
    $user = $proxyParts[2];
    $pass = $proxyParts[3];
} else {
    $host = $proxyParts[0];
    $port = $proxyParts[1];
    $user = '';
    $pass = '';
}

// Kiểm tra proxy HTTP với xác thực (nếu có)
function checkProxy($host, $port, $user = '', $pass = '') {
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, 'https://httpbin.org/ip');
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 5);
    curl_setopt($ch, CURLOPT_PROXY, $host);
    curl_setopt($ch, CURLOPT_PROXYPORT, $port);
    curl_setopt($ch, CURLOPT_HTTPPROXYTUNNEL, true);
    curl_setopt($ch, CURLOPT_PROXYTYPE, CURLPROXY_HTTP);

    // Nếu có xác thực, thêm thông tin đăng nhập
    if ($user && $pass) {
        curl_setopt($ch, CURLOPT_PROXYUSERPWD, "$user:$pass");
    }

    $response = curl_exec($ch);
    $error = curl_error($ch);
    curl_close($ch);

    if ($response !== false && $error === '') {
        // Lấy IP của proxy từ phản hồi
        $responseData = json_decode($response, true);
        return isset($responseData['origin']) ? $responseData['origin'] : 'Unknown';
    }

    return false;
}

// Lấy thông tin quốc gia
function getCountry($ip) {
    $url = "http://ip-api.com/json/{$ip}";
    $response = file_get_contents($url);
    $data = json_decode($response, true);

    if ($data && $data['status'] === 'success') {
        return $data['country'];
    }

    return 'Không xác định';
}

// Kiểm tra proxy và lấy thông tin
$proxyIp = checkProxy($host, $port, $user, $pass);

if ($proxyIp) {
    $country = getCountry($proxyIp);
    echo json_encode(['status' => 'LIVE', 'proxy' => $proxy, 'ip' => $proxyIp, 'country' => $country]);
} else {
    echo json_encode(['status' => 'DIE', 'proxy' => $proxy]);
}
?>
