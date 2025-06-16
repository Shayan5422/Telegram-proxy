FROM alpine:latest

# Install dependencies
RUN apk add --no-cache curl wget openssl

# Download and install mtg binary
RUN wget -O /usr/local/bin/mtg https://github.com/9seconds/mtg/releases/download/v2.1.6/mtg-2.1.6-linux-amd64 && \
    chmod +x /usr/local/bin/mtg

# Create startup script
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'echo "🚀 Starting MTG Telegram Proxy..."' >> /start.sh && \
    echo 'echo "==============================="' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Generate secret if not provided' >> /start.sh && \
    echo 'if [ -z "$SECRET" ]; then' >> /start.sh && \
    echo '  SECRET=$(openssl rand -hex 16)' >> /start.sh && \
    echo 'fi' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Use PORT from environment or default to 443' >> /start.sh && \
    echo 'PROXY_PORT=${PORT:-443}' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "✅ Proxy Configuration:"' >> /start.sh && \
    echo 'echo "   Port: $PROXY_PORT"' >> /start.sh && \
    echo 'echo "   Secret: $SECRET"' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "📱 Add to Telegram:"' >> /start.sh && \
    echo 'echo "   Protocol: MTProto"' >> /start.sh && \
    echo 'echo "   Server: [YOUR_APP_DOMAIN]"' >> /start.sh && \
    echo 'echo "   Port: $PROXY_PORT"' >> /start.sh && \
    echo 'echo "   Secret: $SECRET"' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "🔗 Direct Link:"' >> /start.sh && \
    echo 'echo "tg://proxy?server=[YOUR_DOMAIN]&port=$PROXY_PORT&secret=$SECRET"' >> /start.sh && \
    echo 'echo "==============================="' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Create config file' >> /start.sh && \
    echo 'cat > /tmp/config.toml << EOF' >> /start.sh && \
    echo 'secret = "$SECRET"' >> /start.sh && \
    echo 'bind-to = "0.0.0.0:$PROXY_PORT"' >> /start.sh && \
    echo 'EOF' >> /start.sh && \
    echo '' >> /start.sh && \
    echo 'echo "🔄 Starting proxy server..."' >> /start.sh && \
    echo 'exec /usr/local/bin/mtg run /tmp/config.toml' >> /start.sh && \
    chmod +x /start.sh

# Set environment variables
ENV PORT=443
ENV SECRET=""

# Expose port
EXPOSE $PORT

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:$PORT/ || exit 1

CMD ["/start.sh"] 