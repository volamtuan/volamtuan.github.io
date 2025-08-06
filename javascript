<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trình Hiển Thị Mã HTML, CSS & JavaScript</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #74ebd5 0%, #ACB6E5 100%);
            color: #333;
            margin: 0;
            padding: 0;
        }
        h1, h2 {
            text-align: center;
            color: #fff;
        }
        .container {
            width: 100%;
            max-width: 90%; /* Rút gọn phần chiều rộng */
            margin: 20px auto;
            background-color: #fff;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            padding: 20px;
            border-radius: 12px;
        }
        textarea {
            width: 100%;
            height: 300px;
            border: 1px solid #ccc;
            border-radius: 8px;
            padding: 10px;
            font-family: 'Courier New', monospace;
            margin-bottom: 20px;
            resize: vertical;
        }
        iframe {
            width: 100%;
            height: 800px;
            border: 1px solid #007bff;
            border-radius: 8px;
            margin-top: 20px;
        }
        button {
            background-color: #007bff;
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            margin-right: 10px;
            transition: background-color 0.3s ease;
        }
        button:hover {
            background-color: #0056b3;
        }
        .editor-section {
            margin-bottom: 40px;
        }
        label {
            font-weight: bold;
            color: #007bff;
        }
        .output-section {
            margin-top: 40px;
        }
        .collapsible {
            cursor: pointer;
            padding: 10px;
            width: 100%;
            text-align: left;
            background-color: #007bff;
            color: white;
            border: none;
            outline: none;
            font-size: 16px;
            margin-bottom: 10px;
            border-radius: 8px;
        }
        .content {
            padding: 0 18px;
            display: none;
            overflow: hidden;
            background-color: #f4f7f9;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .content textarea {
            height: 150px;
        }
        #errorOutput {
            color: red;
            text-align: center;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                max-width: 100%;
                padding: 15px;
                margin: 10px auto;
            }
            h1, h2 {
                font-size: 24px;
            }
            textarea {
                height: 200px;
            }
            iframe {
                height: 500px;
            }
            button {
                font-size: 14px;
                padding: 10px 20px;
                margin-bottom: 10px;
            }
            .editor-section {
                margin-bottom: 30px;
            }
        }

        @media (max-width: 480px) {
            h1, h2 {
                font-size: 20px;
            }
            textarea {
                height: 180px;
            }
            iframe {
                height: 400px;
            }
            button {
                font-size: 12px;
                padding: 8px 15px;
            }
            .editor-section {
                margin-bottom: 20px;
            }
        }

        /* Custom display modes */
        .mobile-view {
            width: 450px; /* Tăng kích thước giả lập điện thoại */
            height: 850px; /* Tăng chiều cao giả lập điện thoại */
            margin: 0 auto;
            border: 20px solid #333;
            border-radius: 50px;
            overflow: hidden;
            box-shadow: 0px 0px 20px rgba(0, 0, 0, 0.5);
            position: relative;
        }
        
        .mobile-view::before, .mobile-view::after {
            content: "";
            display: block;
            position: absolute;
            background: #333;
            border-radius: 50%;
        }

        .mobile-view::before {
            width: 60px;
            height: 60px;
            top: -40px;
            left: 50%;
            transform: translateX(-50%);
        }

        .mobile-view::after {
            width: 100px;
            height: 20px;
            bottom: -20px;
            left: 50%;
            transform: translateX(-50%);
        }

        .desktop-view {
            width: 100%; /* Mặc định hiển thị toàn màn hình */
        }
    </style>
</head>
<body>

    <div class="container">
        <h1>Trình Hiển Thị Mã HTML, CSS & JavaScript</h1>

        <!-- Phần chọn giao diện -->
        <div>
            <button onclick="setViewMode('desktop')">Hiển thị trên máy tính</button>
            <button onclick="setViewMode('mobile')">Hiển thị trên điện thoại</button>
        </div>

        <!-- Phần cho HTML -->
        <div class="editor-section">
            <label for="htmlInput">Mã HTML:</label>
            <textarea id="htmlInput" placeholder="Dán mã HTML vào đây..."></textarea>
            <button onclick="copyText('htmlInput')">Copy HTML</button>
            <button onclick="pasteText('htmlInput')">Paste HTML</button>
            <button onclick="clearHtml()">Xóa HTML</button> <!-- Nút xóa HTML -->
            <button onclick="saveHtml()">Lưu HTML</button> <!-- Nút lưu HTML -->
        </div>

        <!-- Phần ẩn cho CSS -->
        <button class="collapsible">Mã CSS</button>
        <div class="content">
            <textarea id="cssInput" placeholder="Dán mã CSS vào đây..."></textarea>
            <button onclick="copyText('cssInput')">Copy CSS</button>
            <button onclick="pasteText('cssInput')">Paste CSS</button>
        </div>

        <!-- Phần ẩn cho JavaScript -->
        <button class="collapsible">Mã JavaScript</button>
        <div class="content">
            <textarea id="jsInput" placeholder="Dán mã JavaScript vào đây..."></textarea>
            <button onclick="copyText('jsInput')">Copy JS</button>
            <button onclick="pasteText('jsInput')">Paste JS</button>
        </div>

        <button onclick="runCode()">Hiển thị</button>
        <button onclick="downloadFile('html')">Tải xuống file HTML</button>
        <button onclick="downloadFile('php')">Tải xuống file PHP</button>

        <div id="errorOutput"></div>

        <!-- Kết quả -->
        <div class="output-section">
            <h2>Kết quả:</h2>
            <div id="viewContainer" class="desktop-view">
                <iframe id="outputFrame"></iframe>
            </div>
        </div>
    </div>

    <script>
        // Load code from localStorage
        document.getElementById('htmlInput').value = localStorage.getItem('htmlCode') || '';
        document.getElementById('cssInput').value = localStorage.getItem('cssCode') || '';
        document.getElementById('jsInput').value = localStorage.getItem('jsCode') || '';

        // Save code to localStorage
        function saveCode() {
            localStorage.setItem('htmlCode', document.getElementById('htmlInput').value);
            localStorage.setItem('cssCode', document.getElementById('cssInput').value);
            localStorage.setItem('jsCode', document.getElementById('jsInput').value);
        }

        // Chức năng lưu HTML
        function saveHtml() {
            localStorage.setItem('htmlCode', document.getElementById('htmlInput').value);
            alert('Đã lưu HTML!');
        }

        // Chức năng xóa HTML
        function clearHtml() {
            document.getElementById('htmlInput').value = '';
            localStorage.removeItem('htmlCode');
            alert('Đã xóa HTML!');
        }

        // Chức năng copy văn bản
        function copyText(elementId) {
            var text = document.getElementById(elementId);
            text.select();
            document.execCommand('copy');
            alert('Đã copy mã!');
        }

        // Chức năng paste văn bản
        function pasteText(elementId) {
            navigator.clipboard.readText().then(function(clipText) {
                document.getElementById(elementId).value = clipText;
            });
        }

        // Chức năng hiển thị mã
        function runCode() {
            saveCode(); // Save the current code to localStorage

            var htmlContent = document.getElementById('htmlInput').value;
            var cssContent = document.getElementById('cssInput').value;
            var jsContent = document.getElementById('jsInput').value;

            var iframe = document.getElementById('outputFrame');
            var iframeDoc = iframe.contentDocument || iframe.contentWindow.document;

            var completeContent = `
                <html>
                    <head>
                        <style>${cssContent}</style>
                    </head>
                    <body>
                        ${htmlContent}
                        <script>
                            try {
                                ${jsContent}
                            } catch (error) {
                                parent.document.getElementById('errorOutput').textContent = 'Lỗi trong mã JavaScript: ' + error.message;
                            }
                        <\/script>
                    </body>
                </html>
            `;

            iframeDoc.open();
            iframeDoc.write(completeContent);
            iframeDoc.close();
        }

        // Chức năng tải xuống file
        function downloadFile(type) {
            var htmlContent = document.getElementById('htmlInput').value;
            var cssContent = document.getElementById('cssInput').value;
            var jsContent = document.getElementById('jsInput').value;

            var completeContent = `
                <html>
                    <head>
                        <style>${cssContent}</style>
                    </head>
                    <body>
                        ${htmlContent}
                        <script>${jsContent}<\/script>
                    </body>
                </html>
            `;

            var blob = new Blob([completeContent], { type: "text/" + type });
            var link = document.createElement("a");
            link.href = URL.createObjectURL(blob);
            link.download = "output." + type;
            link.click();
        }

        // Chức năng mở/đóng các phần ẩn
        var collapsibles = document.getElementsByClassName("collapsible");
        for (var i = 0; i < collapsibles.length; i++) {
            collapsibles[i].addEventListener("click", function() {
                this.classList.toggle("active");
                var content = this.nextElementSibling;
                if (content.style.display === "block") {
                    content.style.display = "none";
                } else {
                    content.style.display = "block";
                }
            });
        }

        // Thay đổi chế độ hiển thị
        function setViewMode(mode) {
            var viewContainer = document.getElementById('viewContainer');
            if (mode === 'mobile') {
                viewContainer.classList.remove('desktop-view');
                viewContainer.classList.add('mobile-view');
            } else {
                viewContainer.classList.remove('mobile-view');
                viewContainer.classList.add('desktop-view');
            }
        }
    </script>

</body>
</html>


