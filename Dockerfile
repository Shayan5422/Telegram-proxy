FROM telegrammessenger/proxy:latest

# Create entrypoint script
RUN echo '#!/bin/bash' > /entrypoint.sh && \
    echo 'set -e' >> /entrypoint.sh && \
    echo 'echo "🚀 Starting Telegram MTProxy..."' >> /entrypoint.sh && \
    echo 'echo "================================"' >> /entrypoint.sh && \
    echo 'if [ -z "$SECRET" ]; then' >> /entrypoint.sh && \
    echo '  SECRET=$(openssl rand -hex 16)' >> /entrypoint.sh && \
    echo 'fi' >> /entrypoint.sh && \
    echo 'PROXY_PORT=${PORT:-443}' >> /entrypoint.sh && \
    echo 'echo "✅ Proxy Configuration:"' >> /entrypoint.sh && \
    echo 'echo "   Port: $PROXY_PORT"' >> /entrypoint.sh && \
    echo 'echo "   Secret: dd$SECRET"' >> /entrypoint.sh && \
    echo 'echo ""' >> /entrypoint.sh && \
    echo 'echo "📱 Add to Telegram:"' >> /entrypoint.sh && \
    echo 'echo "   Protocol: MTProto"' >> /entrypoint.sh && \
    echo 'echo "   Server: [YOUR_APP_DOMAIN]"' >> /entrypoint.sh && \
    echo 'echo "   Port: $PROXY_PORT"' >> /entrypoint.sh && \
    echo 'echo "   Secret: dd$SECRET"' >> /entrypoint.sh && \
    echo 'echo ""' >> /entrypoint.sh && \
    echo 'echo "🔗 Connect Link:"' >> /entrypoint.sh && \
    echo 'echo "https://t.me/proxy?server=[YOUR_DOMAIN]&port=$PROXY_PORT&secret=dd$SECRET"' >> /entrypoint.sh && \
    echo 'echo "================================"' >> /entrypoint.sh && \
    echo 'echo "🔄 Starting proxy server..."' >> /entrypoint.sh && \
    echo 'exec /opt/mtproto-proxy/mtproto-proxy -u nobody -p 8888 -H $PROXY_PORT -S dd$SECRET --aes-pwd /opt/mtproto-proxy/proxy-secret /opt/mtproto-proxy/proxy-multi.conf -M 1' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

# Set environment variables
ENV PORT=443
ENV SECRET=""

# Expose port
EXPOSE $PORT

CMD ["/entrypoint.sh"] 