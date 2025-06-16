FROM python:3.9-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Download MTProxy
RUN curl -o mtprotoproxy.py https://raw.githubusercontent.com/alexbers/mtprotoproxy/master/mtprotoproxy.py

# Generate secret
RUN python3 -c "import secrets; print('dd' + secrets.token_hex(16))" > SECRET

# Create simple web server
RUN echo 'import os, sys, threading, time, subprocess' > app.py && \
    echo 'import http.server, socketserver' >> app.py && \
    echo '' >> app.py && \
    echo 'def get_secret():' >> app.py && \
    echo '    try:' >> app.py && \
    echo '        with open("SECRET", "r") as f:' >> app.py && \
    echo '            return f.read().strip()' >> app.py && \
    echo '    except:' >> app.py && \
    echo '        return "dd" + "0" * 32' >> app.py && \
    echo '' >> app.py && \
    echo 'def get_host():' >> app.py && \
    echo '    return os.environ.get("SPACE_HOST", "localhost")' >> app.py && \
    echo '' >> app.py && \
    echo 'class Handler(http.server.SimpleHTTPRequestHandler):' >> app.py && \
    echo '    def do_GET(self):' >> app.py && \
    echo '        if self.path == "/" or self.path == "/index.html":' >> app.py && \
    echo '            self.send_response(200)' >> app.py && \
    echo '            self.send_header("Content-Type", "text/html; charset=utf-8")' >> app.py && \
    echo '            self.end_headers()' >> app.py && \
    echo '            secret = get_secret()' >> app.py && \
    echo '            host = get_host()' >> app.py && \
    echo '            html = f"""<!DOCTYPE html>' >> app.py && \
    echo '<html dir="rtl" lang="fa"><head><meta charset="UTF-8">' >> app.py && \
    echo '<title>🚀 تلگرام پروکسی فعال</title>' >> app.py && \
    echo '<style>' >> app.py && \
    echo 'body{{font-family:Tahoma,sans-serif;direction:rtl;margin:0;padding:20px;' >> app.py && \
    echo 'background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);min-height:100vh}}' >> app.py && \
    echo '.container{{max-width:600px;margin:50px auto;background:white;border-radius:20px;' >> app.py && \
    echo 'padding:40px;box-shadow:0 15px 35px rgba(0,0,0,0.1)}}' >> app.py && \
    echo 'h1{{color:#333;text-align:center;margin-bottom:30px;font-size:2.5em}}' >> app.py && \
    echo '.status{{background:#28a745;color:white;padding:20px;border-radius:10px;' >> app.py && \
    echo 'text-align:center;margin:30px 0;font-weight:bold;font-size:1.2em}}' >> app.py && \
    echo '.config{{background:#f8f9fa;padding:25px;border-radius:10px;margin:25px 0}}' >> app.py && \
    echo '.item{{margin:20px 0}}.label{{font-weight:bold;color:#495057;margin-bottom:8px;font-size:1.1em}}' >> app.py && \
    echo '.value{{background:white;padding:15px;border-radius:8px;border:2px solid #dee2e6;' >> app.py && \
    echo 'font-family:monospace;word-break:break-all;font-size:0.95em}}' >> app.py && \
    echo '.btn{{display:block;background:#0088cc;color:white;padding:18px 30px;text-decoration:none;' >> app.py && \
    echo 'border-radius:10px;font-weight:bold;margin:25px auto;text-align:center;max-width:300px;' >> app.py && \
    echo 'font-size:1.1em}}.btn:hover{{background:#006699}}' >> app.py && \
    echo '.btn2{{background:#6c757d;font-size:0.95em;padding:12px 25px;max-width:250px}}' >> app.py && \
    echo '.instructions{{background:#e3f2fd;padding:25px;border-radius:10px;margin:30px 0}}' >> app.py && \
    echo '.instructions h3{{color:#1976d2;margin-bottom:20px}}' >> app.py && \
    echo '.footer{{text-align:center;margin-top:40px;color:#6c757d;font-size:0.9em}}' >> app.py && \
    echo '</style></head><body><div class="container">' >> app.py && \
    echo '<h1>🚀 تلگرام پروکسی</h1>' >> app.py && \
    echo '<div class="status">✅ پروکسی فعال و آماده اتصال است</div>' >> app.py && \
    echo '<div class="config"><h3>📱 اطلاعات اتصال:</h3>' >> app.py && \
    echo '<div class="item"><div class="label">🌐 آدرس سرور:</div><div class="value">{host}</div></div>' >> app.py && \
    echo '<div class="item"><div class="label">🔌 پورت:</div><div class="value">8080</div></div>' >> app.py && \
    echo '<div class="item"><div class="label">🔑 رمز عبور:</div><div class="value">{secret}</div></div></div>' >> app.py && \
    echo '<a href="tg://proxy?server={host}&port=8080&secret={secret}" class="btn">🔗 اتصال سریع</a>' >> app.py && \
    echo '<a href="https://t.me/proxy?server={host}&port=8080&secret={secret}" class="btn btn2">📱 اتصال مرورگر</a>' >> app.py && \
    echo '<div class="instructions"><h3>📋 راهنما:</h3><ol>' >> app.py && \
    echo '<li>تلگرام → Settings → Proxy Settings</li>' >> app.py && \
    echo '<li>Add Proxy → MTProto</li>' >> app.py && \
    echo '<li>اطلاعات بالا را وارد کنید</li>' >> app.py && \
    echo '<li>Save و Enable کنید</li></ol></div>' >> app.py && \
    echo '<div class="footer"><p>🌟 رایگان و امن</p><p>🔒 MTProto Protocol</p></div>' >> app.py && \
    echo '</div></body></html>"""' >> app.py && \
    echo '            self.wfile.write(html.encode("utf-8"))' >> app.py && \
    echo '        else:' >> app.py && \
    echo '            super().do_GET()' >> app.py && \
    echo '' >> app.py && \
    echo 'def run_proxy():' >> app.py && \
    echo '    try:' >> app.py && \
    echo '        secret = get_secret()' >> app.py && \
    echo '        print(f"🚀 Starting MTProxy: {secret}")' >> app.py && \
    echo '        cmd = [sys.executable, "mtprotoproxy.py", "-p", "8080", "-s", secret]' >> app.py && \
    echo '        subprocess.run(cmd, check=True)' >> app.py && \
    echo '    except Exception as e:' >> app.py && \
    echo '        print(f"❌ Proxy error: {e}")' >> app.py && \
    echo '' >> app.py && \
    echo 'def run_web():' >> app.py && \
    echo '    PORT = 7860' >> app.py && \
    echo '    print(f"🌐 Web server: {PORT}")' >> app.py && \
    echo '    with socketserver.TCPServer(("", PORT), Handler) as httpd:' >> app.py && \
    echo '        httpd.serve_forever()' >> app.py && \
    echo '' >> app.py && \
    echo 'if __name__ == "__main__":' >> app.py && \
    echo '    print("🚀 Starting service...")' >> app.py && \
    echo '    proxy_thread = threading.Thread(target=run_proxy, daemon=True)' >> app.py && \
    echo '    proxy_thread.start()' >> app.py && \
    echo '    time.sleep(2)' >> app.py && \
    echo '    run_web()' >> app.py

ENV PORT=7860
EXPOSE 7860 8080

CMD ["python3", "app.py"] 