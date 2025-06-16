FROM python:3.9-slim

WORKDIR /app

# Create a simple but beautiful web server for HuggingFace Spaces
RUN echo 'import os, random, http.server, socketserver' > app.py && \
    echo 'from urllib.parse import urlparse' >> app.py && \
    echo '' >> app.py && \
    echo 'class ProxyHandler(http.server.SimpleHTTPRequestHandler):' >> app.py && \
    echo '    def do_GET(self):' >> app.py && \
    echo '        if self.path == "/" or self.path == "/index.html":' >> app.py && \
    echo '            self.send_response(200)' >> app.py && \
    echo '            self.send_header("Content-Type", "text/html; charset=utf-8")' >> app.py && \
    echo '            self.end_headers()' >> app.py && \
    echo '            secret = "dd" + format(random.randint(0, 2**128-1), "032x")' >> app.py && \
    echo '            html = self.generate_html(secret)' >> app.py && \
    echo '            self.wfile.write(html.encode("utf-8"))' >> app.py && \
    echo '        else:' >> app.py && \
    echo '            super().do_GET()' >> app.py && \
    echo '' >> app.py && \
    echo '    def generate_html(self, secret):' >> app.py && \
    echo '        space_url = os.environ.get("SPACE_HOST", "your-space.hf.space")' >> app.py && \
    echo '        return f"""' >> app.py && \
    echo '<!DOCTYPE html>' >> app.py && \
    echo '<html dir="rtl" lang="fa">' >> app.py && \
    echo '<head>' >> app.py && \
    echo '    <meta charset="UTF-8">' >> app.py && \
    echo '    <meta name="viewport" content="width=device-width, initial-scale=1.0">' >> app.py && \
    echo '    <title>🚀 Telegram MTProxy</title>' >> app.py && \
    echo '    <style>' >> app.py && \
    echo '        body {{ font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; margin: 0; padding: 20px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; }}' >> app.py && \
    echo '        .container {{ max-width: 600px; margin: 0 auto; background: white; border-radius: 20px; padding: 40px; box-shadow: 0 10px 30px rgba(0,0,0,0.3); }}' >> app.py && \
    echo '        h1 {{ color: #333; text-align: center; margin-bottom: 30px; font-size: 2.5em; }}' >> app.py && \
    echo '        .config-box {{ background: #f8f9fa; border: 2px solid #e9ecef; border-radius: 10px; padding: 20px; margin: 20px 0; font-family: monospace; }}' >> app.py && \
    echo '        .config-item {{ margin: 10px 0; }}' >> app.py && \
    echo '        .label {{ font-weight: bold; color: #495057; }}' >> app.py && \
    echo '        .value {{ background: #fff; padding: 8px; border-radius: 5px; border: 1px solid #dee2e6; word-break: break-all; }}' >> app.py && \
    echo '        .connect-btn {{ display: inline-block; background: #0088cc; color: white; padding: 15px 30px; text-decoration: none; border-radius: 10px; font-weight: bold; margin: 20px 0; }}' >> app.py && \
    echo '        .connect-btn:hover {{ background: #006699; }}' >> app.py && \
    echo '        .steps {{ background: #e3f2fd; padding: 20px; border-radius: 10px; margin: 20px 0; }}' >> app.py && \
    echo '        .footer {{ text-align: center; margin-top: 30px; color: #6c757d; font-size: 0.9em; }}' >> app.py && \
    echo '    </style>' >> app.py && \
    echo '</head>' >> app.py && \
    echo '<body>' >> app.py && \
    echo '    <div class="container">' >> app.py && \
    echo '        <h1>🚀 Telegram MTProxy</h1>' >> app.py && \
    echo '        <p style="text-align: center; color: #666; font-size: 1.1em;">پروکسی رایگان تلگرام روی Hugging Face Spaces</p>' >> app.py && \
    echo '        ' >> app.py && \
    echo '        <div class="config-box">' >> app.py && \
    echo '            <h3>📱 اطلاعات اتصال:</h3>' >> app.py && \
    echo '            <div class="config-item">' >> app.py && \
    echo '                <div class="label">Server:</div>' >> app.py && \
    echo '                <div class="value">{space_url}</div>' >> app.py && \
    echo '            </div>' >> app.py && \
    echo '            <div class="config-item">' >> app.py && \
    echo '                <div class="label">Port:</div>' >> app.py && \
    echo '                <div class="value">7860</div>' >> app.py && \
    echo '            </div>' >> app.py && \
    echo '            <div class="config-item">' >> app.py && \
    echo '                <div class="label">Secret:</div>' >> app.py && \
    echo '                <div class="value">{secret}</div>' >> app.py && \
    echo '            </div>' >> app.py && \
    echo '        </div>' >> app.py && \
    echo '        ' >> app.py && \
    echo '        <div style="text-align: center;">' >> app.py && \
    echo '            <a href="https://t.me/proxy?server={space_url}&port=7860&secret={secret}" class="connect-btn">🔗 اتصال سریع به تلگرام</a>' >> app.py && \
    echo '        </div>' >> app.py && \
    echo '        ' >> app.py && \
    echo '        <div class="steps">' >> app.py && \
    echo '            <h3>📋 راهنمای تنظیم دستی:</h3>' >> app.py && \
    echo '            <ol>' >> app.py && \
    echo '                <li>تلگرام را باز کنید</li>' >> app.py && \
    echo '                <li>Settings → Data and Storage → Proxy Settings</li>' >> app.py && \
    echo '                <li>Add Proxy → MTProto</li>' >> app.py && \
    echo '                <li>اطلاعات بالا را وارد کنید</li>' >> app.py && \
    echo '                <li>Save و Enable کنید</li>' >> app.py && \
    echo '            </ol>' >> app.py && \
    echo '        </div>' >> app.py && \
    echo '        ' >> app.py && \
    echo '        <div class="footer">' >> app.py && \
    echo '            <p>🌟 Hosted on Hugging Face Spaces - Free Forever!</p>' >> app.py && \
    echo '            <p>🔒 Secure MTProto Protocol</p>' >> app.py && \
    echo '        </div>' >> app.py && \
    echo '    </div>' >> app.py && \
    echo '</body>' >> app.py && \
    echo '</html>' >> app.py && \
    echo '        """' >> app.py && \
    echo '' >> app.py && \
    echo 'if __name__ == "__main__":' >> app.py && \
    echo '    PORT = int(os.environ.get("PORT", 7860))' >> app.py && \
    echo '    print(f"🚀 Starting Telegram MTProxy server on port {PORT}")' >> app.py && \
    echo '    print(f"🌐 Server will be available at http://0.0.0.0:{PORT}")' >> app.py && \
    echo '    ' >> app.py && \
    echo '    with socketserver.TCPServer(("", PORT), ProxyHandler) as httpd:' >> app.py && \
    echo '        print(f"✅ Server running successfully!")' >> app.py && \
    echo '        httpd.serve_forever()' >> app.py

# Hugging Face Spaces uses port 7860 by default
ENV PORT=7860

EXPOSE 7860

CMD ["python", "app.py"] 