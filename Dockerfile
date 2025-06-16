FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    git \
    xxd \
    && rm -rf /var/lib/apt/lists/*

# Clone and build MTProxy from the community fork
RUN git clone https://github.com/GetPageSpeed/MTProxy /opt/MTProxy
WORKDIR /opt/MTProxy

# Build MTProxy
RUN make

# Create MTProxy directory and copy binary
RUN mkdir -p /opt/mtproxy && \
    cp objs/bin/mtproto-proxy /opt/mtproxy/

# Download Telegram configs
WORKDIR /opt/mtproxy
RUN curl -s https://core.telegram.org/getProxySecret -o proxy-secret && \
    curl -s https://core.telegram.org/getProxyConfig -o proxy-multi.conf

# Create mtproxy user
RUN useradd -m -s /bin/false mtproxy && \
    chown -R mtproxy:mtproxy /opt/mtproxy

# Create startup script
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'SECRET=${SECRET:-$(head -c 16 /dev/urandom | xxd -ps)}' >> /start.sh && \
    echo 'PORT=${PORT:-443}' >> /start.sh && \
    echo 'echo "==================================="' >> /start.sh && \
    echo 'echo "Telegram MTProxy is starting..."' >> /start.sh && \
    echo 'echo "Port: $PORT"' >> /start.sh && \
    echo 'echo "Secret: dd$SECRET"' >> /start.sh && \
    echo 'echo "==================================="' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "Add this proxy to Telegram:"' >> /start.sh && \
    echo 'echo "Server: YOUR_RAILWAY_DOMAIN"' >> /start.sh && \
    echo 'echo "Port: $PORT"' >> /start.sh && \
    echo 'echo "Secret: dd$SECRET"' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'echo "==================================="' >> /start.sh && \
    echo 'exec /opt/mtproxy/mtproto-proxy -u mtproxy -p 8888 -H $PORT -S dd$SECRET --aes-pwd /opt/mtproxy/proxy-secret /opt/mtproxy/proxy-multi.conf -M 1' >> /start.sh && \
    chmod +x /start.sh

EXPOSE $PORT 8888

CMD ["/start.sh"] 