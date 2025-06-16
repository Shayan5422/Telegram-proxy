FROM telegrammessenger/proxy:latest

# Set environment variables
ENV SECRET=""
ENV WORKERS=1

# Create a simple startup script
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'echo "========================================="' >> /start.sh && \
    echo 'echo "🚀 Starting Telegram MTProxy..."' >> /start.sh && \
    echo 'echo "========================================="' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Generate secret if not provided' >> /start.sh && \
    echo 'if [ -z "$SECRET" ]; then' >> /start.sh && \
    echo '  SECRET=$(openssl rand -hex 16)' >> /start.sh && \
    echo 'fi' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Use PORT from environment or default to 443' >> /start.sh && \
    echo 'PROXY_PORT=${PORT:-443}' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "✅ MTProxy Configuration:"' >> /start.sh && \
    echo 'echo "   Port: $PROXY_PORT"' >> /start.sh && \
    echo 'echo "   Secret: dd$SECRET"' >> /start.sh && \
    echo 'echo "   Stats Port: 8888"' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "📱 Add to Telegram:"' >> /start.sh && \
    echo 'echo "   Protocol: MTProto"' >> /start.sh && \
    echo 'echo "   Server: YOUR_APP_DOMAIN"' >> /start.sh && \
    echo 'echo "   Port: $PROXY_PORT"' >> /start.sh && \
    echo 'echo "   Secret: dd$SECRET"' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "🔗 Quick Connect URL:"' >> /start.sh && \
    echo 'echo "   https://t.me/proxy?server=YOUR_DOMAIN&port=$PROXY_PORT&secret=dd$SECRET"' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "========================================="' >> /start.sh && \
    echo 'echo "🔄 Starting proxy server..."' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Start the MTProxy server' >> /start.sh && \
    echo 'exec /mtproto-proxy/mtproto-proxy \' >> /start.sh && \
    echo '  -u nobody \' >> /start.sh && \
    echo '  -p 8888 \' >> /start.sh && \
    echo '  -H $PROXY_PORT \' >> /start.sh && \
    echo '  -S dd$SECRET \' >> /start.sh && \
    echo '  --aes-pwd /mtproto-proxy/proxy-secret \' >> /start.sh && \
    echo '  /mtproto-proxy/proxy-multi.conf \' >> /start.sh && \
    echo '  -M $WORKERS' >> /start.sh && \
    chmod +x /start.sh

# Expose ports
EXPOSE $PORT 8888

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8888/stats || exit 1

CMD ["/start.sh"] 