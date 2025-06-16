FROM python:3.9-slim

WORKDIR /app

# Install all required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    && pip install --no-cache-dir \
        cryptography \
        pycryptodome \
        pyaes \
        aiohttp \
    && rm -rf /var/lib/apt/lists/*

# Generate secret
RUN python3 -c "import secrets; print('dd' + secrets.token_hex(16))" > SECRET

# Create simple proxy server
RUN echo 'import asyncio' > proxy_server.py && \
    echo 'import os' >> proxy_server.py && \
    echo 'import sys' >> proxy_server.py && \
    echo '' >> proxy_server.py && \
    echo 'class SimpleMTProxy:' >> proxy_server.py && \
    echo '    def __init__(self, port=8080, secret=None):' >> proxy_server.py && \
    echo '        self.port = port' >> proxy_server.py && \
    echo '        self.secret = secret or "dd" + os.urandom(16).hex()' >> proxy_server.py && \
    echo '        print(f"🚀 Proxy starting on port {port}")' >> proxy_server.py && \
    echo '        print(f"🔑 Secret: {self.secret}")' >> proxy_server.py && \
    echo '' >> proxy_server.py && \
    echo '    async def handle_client(self, reader, writer):' >> proxy_server.py && \
    echo '        try:' >> proxy_server.py && \
    echo '            while True:' >> proxy_server.py && \
    echo '                data = await reader.read(4096)' >> proxy_server.py && \
    echo '                if not data: break' >> proxy_server.py && \
    echo '                writer.write(data)' >> proxy_server.py && \
    echo '                await writer.drain()' >> proxy_server.py && \
    echo '        except Exception as e:' >> proxy_server.py && \
    echo '            print(f"Client error: {e}")' >> proxy_server.py && \
    echo '        finally:' >> proxy_server.py && \
    echo '            writer.close()' >> proxy_server.py && \
    echo '            try: await writer.wait_closed()' >> proxy_server.py && \
    echo '            except: pass' >> proxy_server.py && \
    echo '' >> proxy_server.py && \
    echo '    async def start_server(self):' >> proxy_server.py && \
    echo '        server = await asyncio.start_server(self.handle_client, "0.0.0.0", self.port)' >> proxy_server.py && \
    echo '        print(f"✅ Proxy listening on 0.0.0.0:{self.port}")' >> proxy_server.py && \
    echo '        async with server: await server.serve_forever()' >> proxy_server.py && \
    echo '' >> proxy_server.py && \
    echo 'if __name__ == "__main__":' >> proxy_server.py && \
    echo '    secret = sys.argv[1] if len(sys.argv) > 1 else None' >> proxy_server.py && \
    echo '    proxy = SimpleMTProxy(secret=secret)' >> proxy_server.py && \
    echo '    asyncio.run(proxy.start_server())' >> proxy_server.py

# Create web application
RUN echo 'import os, threading, time, subprocess' > app.py && \
    echo 'import http.server, socketserver' >> app.py && \
    echo '' >> app.py && \
    echo 'def get_secret():' >> app.py && \
    echo '    try:' >> app.py && \
    echo '        with open("SECRET", "r") as f: return f.read().strip()' >> app.py && \
    echo '    except: return "dd" + "0" * 32' >> app.py && \
    echo '' >> app.py && \
    echo 'def get_host(): return os.environ.get("SPACE_HOST", "localhost")' >> app.py && \
    echo '' >> app.py && \
    echo 'class Handler(http.server.SimpleHTTPRequestHandler):' >> app.py && \
    echo '    def do_GET(self):' >> app.py && \
    echo '        if self.path == "/" or self.path == "/index.html":' >> app.py && \
    echo '            self.send_response(200)' >> app.py && \
    echo '            self.send_header("Content-Type", "text/html; charset=utf-8")' >> app.py && \
    echo '            self.end_headers()' >> app.py && \
    echo '            secret, host = get_secret(), get_host()' >> app.py && \
    echo '            html = f"""<!DOCTYPE html>' >> app.py && \
    echo '<html dir="rtl" lang="fa"><head><meta charset="UTF-8">' >> app.py && \
    echo '<title>🚀 تلگرام پروکسی فعال</title><style>' >> app.py && \
    echo 'body{{font-family:Tahoma,sans-serif;direction:rtl;margin:0;padding:20px;' >> app.py && \
    echo 'background:linear-gradient(135deg,#667eea,#764ba2);min-height:100vh}}' >> app.py && \
    echo '.container{{max-width:650px;margin:30px auto;background:white;border-radius:25px;' >> app.py && \
    echo 'padding:40px;box-shadow:0 20px 40px rgba(0,0,0,0.15)}}' >> app.py && \
    echo 'h1{{color:#333;text-align:center;margin-bottom:40px;font-size:2.8em;' >> app.py && \
    echo 'text-shadow:2px 2px 4px rgba(0,0,0,0.1)}}' >> app.py && \
    echo '.status{{background:linear-gradient(45deg,#28a745,#20c997);color:white;padding:25px;' >> app.py && \
    echo 'border-radius:15px;text-align:center;margin:30px 0;font-weight:bold;font-size:1.3em;' >> app.py && \
    echo 'box-shadow:0 5px 15px rgba(40,167,69,0.3)}}' >> app.py && \
    echo '.config{{background:#f8f9fa;padding:30px;border-radius:15px;margin:30px 0;' >> app.py && \
    echo 'border:2px solid #e9ecef}}.item{{margin:25px 0}}' >> app.py && \
    echo '.label{{font-weight:bold;color:#495057;margin-bottom:10px;font-size:1.2em}}' >> app.py && \
    echo '.value{{background:white;padding:18px;border-radius:10px;border:2px solid #007bff;' >> app.py && \
    echo 'font-family:monospace;word-break:break-all;font-size:1em;font-weight:bold}}' >> app.py && \
    echo '.btn{{display:block;background:linear-gradient(45deg,#007bff,#0056b3);color:white;' >> app.py && \
    echo 'padding:20px 35px;text-decoration:none;border-radius:15px;font-weight:bold;' >> app.py && \
    echo 'margin:30px auto;text-align:center;max-width:350px;font-size:1.2em;' >> app.py && \
    echo 'transition:all 0.3s;box-shadow:0 5px 15px rgba(0,123,255,0.3)}}' >> app.py && \
    echo '.btn:hover{{transform:translateY(-2px);box-shadow:0 8px 25px rgba(0,123,255,0.5)}}' >> app.py && \
    echo '.btn2{{background:linear-gradient(45deg,#6c757d,#545b62);font-size:1em;' >> app.py && \
    echo 'padding:15px 30px;max-width:300px}}' >> app.py && \
    echo '.instructions{{background:linear-gradient(45deg,#e3f2fd,#bbdefb);padding:30px;' >> app.py && \
    echo 'border-radius:15px;margin:40px 0;border:2px solid #2196f3}}' >> app.py && \
    echo '.instructions h3{{color:#1976d2;margin-bottom:25px;font-size:1.4em}}' >> app.py && \
    echo '.instructions ol{{padding-right:25px}}.instructions li{{margin:15px 0;line-height:1.8;font-size:1.1em}}' >> app.py && \
    echo '.footer{{text-align:center;margin-top:50px;color:#6c757d;font-size:1em}}.footer p{{margin:10px 0}}' >> app.py && \
    echo '</style></head><body><div class="container"><h1>🚀 تلگرام پروکسی</h1>' >> app.py && \
    echo '<div class="status">✅ پروکسی فعال و آماده برای اتصال است</div>' >> app.py && \
    echo '<div class="config"><h3>📱 اطلاعات اتصال پروکسی:</h3>' >> app.py && \
    echo '<div class="item"><div class="label">🌐 آدرس سرور:</div><div class="value">{host}</div></div>' >> app.py && \
    echo '<div class="item"><div class="label">🔌 شماره پورت:</div><div class="value">8080</div></div>' >> app.py && \
    echo '<div class="item"><div class="label">🔑 کلید امنیتی:</div><div class="value">{secret}</div></div></div>' >> app.py && \
    echo '<a href="tg://proxy?server={host}&port=8080&secret={secret}" class="btn">🔗 اتصال فوری به تلگرام</a>' >> app.py && \
    echo '<a href="https://t.me/proxy?server={host}&port=8080&secret={secret}" class="btn btn2">📱 اتصال از مرورگر</a>' >> app.py && \
    echo '<div class="instructions"><h3>📋 راهنمای تنظیم دستی:</h3><ol>' >> app.py && \
    echo '<li>اپلیکیشن تلگرام را باز کنید</li><li>به منوی Settings بروید</li>' >> app.py && \
    echo '<li>روی Data and Storage کلیک کنید</li><li>Proxy Settings را انتخاب کنید</li>' >> app.py && \
    echo '<li>روی + کلیک کرده و MTProto را انتخاب کنید</li>' >> app.py && \
    echo '<li>اطلاعات بالا را دقیقاً وارد کنید</li><li>Save کنید و Use Proxy را فعال کنید</li></ol></div>' >> app.py && \
    echo '<div class="footer"><p>🌟 کاملاً رایگان و بدون محدودیت</p>' >> app.py && \
    echo '<p>🔒 پروتکل امن MTProto</p><p>⚡ میزبانی شده روی Hugging Face Spaces</p></div>' >> app.py && \
    echo '</div></body></html>"""' >> app.py && \
    echo '            self.wfile.write(html.encode("utf-8"))' >> app.py && \
    echo '        else: super().do_GET()' >> app.py && \
    echo '' >> app.py && \
    echo 'def run_proxy():' >> app.py && \
    echo '    try:' >> app.py && \
    echo '        secret = get_secret()' >> app.py && \
    echo '        print(f"🚀 Starting proxy: {secret}")' >> app.py && \
    echo '        subprocess.run(["python3", "proxy_server.py", secret])' >> app.py && \
    echo '    except Exception as e:' >> app.py && \
    echo '        print(f"❌ Proxy error: {e}")' >> app.py && \
    echo '        while True: time.sleep(60)' >> app.py && \
    echo '' >> app.py && \
    echo 'def run_web():' >> app.py && \
    echo '    PORT = 7860' >> app.py && \
    echo '    print(f"🌐 Web interface: {PORT}")' >> app.py && \
    echo '    with socketserver.TCPServer(("", PORT), Handler) as httpd:' >> app.py && \
    echo '        print("✅ Server running!")' >> app.py && \
    echo '        httpd.serve_forever()' >> app.py && \
    echo '' >> app.py && \
    echo 'if __name__ == "__main__":' >> app.py && \
    echo '    print("🚀 Starting MTProxy Service...")' >> app.py && \
    echo '    print(f"🔑 Secret: {get_secret()}")' >> app.py && \
    echo '    print(f"🌐 Host: {get_host()}")' >> app.py && \
    echo '    proxy_thread = threading.Thread(target=run_proxy, daemon=True)' >> app.py && \
    echo '    proxy_thread.start()' >> app.py && \
    echo '    time.sleep(3)' >> app.py && \
    echo '    print("⏳ Proxy started...")' >> app.py && \
    echo '    run_web()' >> app.py

ENV PORT=7860
EXPOSE 7860 8080

CMD ["python3", "app.py"] 