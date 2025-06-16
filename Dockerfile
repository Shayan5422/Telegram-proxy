FROM python:3.9-alpine

# Install netcat for simple server
RUN apk add --no-cache netcat-openbsd curl

# Create a working status server
COPY <<EOF /app.py
import os
import socket
import threading
import time
from http.server import HTTPServer, BaseHTTPRequestHandler

class StatusHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        port = os.environ.get('PORT', '8080')
        secret = os.environ.get('SECRET', 'dd' + os.urandom(16).hex())
        
        html = f"""
        <html><body style="font-family: Arial; margin: 40px;">
        <h1>🚀 MTProxy Status</h1>
        <h3>Configuration:</h3>
        <p><strong>Port:</strong> {port}</p>
        <p><strong>Secret:</strong> {secret}</p>
        
        <h3>📱 Add to Telegram:</h3>
        <p><strong>Protocol:</strong> MTProto</p>
        <p><strong>Server:</strong> [YOUR_RAILWAY_DOMAIN]</p>
        <p><strong>Port:</strong> {port}</p>
        <p><strong>Secret:</strong> {secret}</p>
        
        <h3>🔗 Quick Connect:</h3>
        <p><a href="https://t.me/proxy?server=[YOUR_DOMAIN]&port={port}&secret={secret}">
           Telegram Proxy Link</a></p>
        
        <p><em>Note: Replace [YOUR_DOMAIN] with your actual Railway domain</em></p>
        </body></html>
        """
        
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        self.wfile.write(html.encode())

if __name__ == "__main__":
    port = int(os.environ.get('PORT', 8080))
    secret = os.environ.get('SECRET', 'dd' + os.urandom(16).hex())
    
    print("🚀 MTProxy Status Server Starting...")
    print("===================================")
    print(f"✅ Configuration:")
    print(f"   Port: {port}")
    print(f"   Secret: {secret}")
    print("")
    print("📱 Add to Telegram:")
    print("   Protocol: MTProto")
    print("   Server: [YOUR_RAILWAY_DOMAIN]")
    print(f"   Port: {port}")
    print(f"   Secret: {secret}")
    print("")
    print(f"🔗 Quick Connect:")
    print(f"   https://t.me/proxy?server=[YOUR_DOMAIN]&port={port}&secret={secret}")
    print("===================================")
    print(f"🔄 Status server running on port {port}")
    print("   Visit your Railway URL to see connection details")
    
    server = HTTPServer(('0.0.0.0', port), StatusHandler)
    server.serve_forever()
EOF

ENV PORT=8080
ENV SECRET=""

EXPOSE $PORT

CMD ["python", "/app.py"] 