<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Mini HTML/JS Runner</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body { margin:0; font-family: monospace; background:#f5f5f5; }
header { background:#343a40; color:white; padding:10px; text-align:center; font-size:1.2em; }
.container { display:flex; height:calc(100vh - 50px); }
.sidebar { width:250px; border-right:1px solid #ccc; background:white; overflow-y:auto; }
.sidebar ul { list-style:none; padding:0; margin:0; }
.sidebar li { padding:10px; border-bottom:1px solid #eee; display:flex; justify-content:space-between; align-items:center; cursor:pointer; }
.sidebar li.active { background:#007bff; color:white; }
.sidebar li button { background:red; color:white; border:none; border-radius:3px; cursor:pointer; }
.main { flex:1; display:flex; flex-direction:column; }
.editor { flex:1; margin:10px; display:flex; flex-direction:column; }
textarea { flex:1; width:100%; padding:10px; border:1px solid #ccc; border-radius:4px; resize:none; font-family:monospace; }
.controls { margin:10px; }
iframe { flex:1; border:1px solid #ccc; margin:10px; background:white; }
#dropzone { border:2px dashed #007bff; padding:20px; text-align:center; margin:10px; color:#007bff; cursor:pointer; }
#dropzone.dragover { background:#e3f2fd; }
</style>
</head>
<body>
<header>Mini HTML/JS Runner - Client Only</header>
<div class="container">
    <div class="sidebar">
        <button class="btn btn-primary w-100 my-2" id="addTab">➕ Thêm Tab</button>
        <ul id="tabList"></ul>
        <button class="btn btn-success w-100 my-2" id="downloadBackup">📥 Lưu Backup</button>
        <button class="btn btn-danger w-100 my-2" id="clearAll">🗑️ Xoá tất cả</button>
        <div id="dropzone">Kéo & thả file .html vào đây</div>
        <input type="file" id="fileUpload" accept=".html" style="display:none">
    </div>
    <div class="main">
        <div class="editor">
            <textarea id="codeArea" placeholder="Dán code HTML/JS vào đây..."></textarea>
        </div>
        <div class="controls">
            <button class="btn btn-success" id="runBtn">▶ Chạy</button>
            <button class="btn btn-info" id="viewBtn">👁️ Xem HTML</button>
        </div>
        <iframe id="preview"></iframe>
    </div>
</div>
<script>
let tabs = [];
let currentTab = null;

// Load saved tabs
if(localStorage.getItem("tabsData")) {
    tabs = JSON.parse(localStorage.getItem("tabsData"));
}

// Elements
const tabList = document.getElementById("tabList");
const codeArea = document.getElementById("codeArea");
const preview = document.getElementById("preview");

// Functions
function saveTabs() {
    localStorage.setItem("tabsData", JSON.stringify(tabs));
}
function renderTabs() {
    tabList.innerHTML = "";
    tabs.forEach((t, i) => {
        const li = document.createElement("li");
        li.textContent = t.title;
        li.className = (currentTab===i)?"active":"";
        li.addEventListener("click",()=>selectTab(i));
        const btn = document.createElement("button");
        btn.textContent="❌";
        btn.addEventListener("click",(e)=>{e.stopPropagation(); removeTab(i);});
        li.appendChild(btn);
        tabList.appendChild(li);
    });
}
function selectTab(i) {
    currentTab=i;
    codeArea.value = tabs[i].code;
    renderTabs();
    runCode();
}
function addTab() {
    const title = "Tab "+(tabs.length+1);
    tabs.push({title, code:""});
    currentTab=tabs.length-1;
    renderTabs();
    codeArea.value="";
    saveTabs();
}
function removeTab(i) {
    if(i===currentTab) currentTab=null;
    tabs.splice(i,1);
    currentTab = tabs.length?0:null;
    renderTabs();
    if(currentTab!==null) codeArea.value=tabs[currentTab].code;
    else codeArea.value="";
    saveTabs();
}
function runCode() {
    if(currentTab===null) return;
    const code = codeArea.value;
    preview.srcdoc = code;
    tabs[currentTab].code = code;
    saveTabs();
}
function viewHTML() {
    const code = codeArea.value;
    const w = window.open("","_blank","width=800,height=600,scrollbars=yes");
    w.document.write("<pre>"+code.replace(/</g,"&lt;").replace(/>/g,"&gt;")+"</pre>");
}
addTab();
renderTabs();

// Event listeners
document.getElementById("addTab").addEventListener("click", addTab);
document.getElementById("runBtn").addEventListener("click", runCode);
document.getElementById("viewBtn").addEventListener("click", viewHTML);
document.getElementById("clearAll").addEventListener("click", ()=>{
    if(confirm("Xoá tất cả dữ liệu?")){tabs=[];currentTab=null;codeArea.value="";renderTabs();saveTabs();}
});
document.getElementById("downloadBackup").addEventListener("click",()=>{
    if(!tabs.length)return alert("Chưa có tab nào để lưu");
    const blob = new Blob([JSON.stringify(tabs)],{type:"application/json"});
    const a = document.createElement("a");
    a.href=URL.createObjectURL(blob);
    a.download="backup_tabs.json";
    a.click();
    URL.revokeObjectURL(a.href);
});

// Drag & drop
const dropzone = document.getElementById("dropzone");
dropzone.addEventListener("click",()=>document.getElementById("fileUpload").click());
dropzone.addEventListener("dragover",e=>{e.preventDefault();dropzone.classList.add("dragover");});
dropzone.addEventListener("dragleave",e=>{dropzone.classList.remove("dragover");});
dropzone.addEventListener("drop",e=>{
    e.preventDefault(); dropzone.classList.remove("dragover");
    const file = e.dataTransfer.files[0];
    if(!file) return;
    const reader = new FileReader();
    reader.onload = ev=>{
        if(currentTab===null)addTab();
        codeArea.value = ev.target.result;
        runCode();
    };
    reader.readAsText(file);
});
document.getElementById("fileUpload").addEventListener("change",function(){
    const file = this.files[0];
    if(!file) return;
    const reader = new FileReader();
    reader.onload = ev=>{
        if(currentTab===null)addTab();
        codeArea.value = ev.target.result;
        runCode();
    };
    reader.readAsText(file);
});
</script>
</body>
</html>
