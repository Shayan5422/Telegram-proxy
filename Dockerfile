FROM alpine:latest

# Install dependencies
RUN apk add --no-cache bash curl openssl

# Download working MTG binary
RUN curl -L https://github.com/9seconds/mtg/releases/download/v2.1.6/mtg-linux-amd64 -o /usr/bin/mtg && chmod +x /usr/bin/mtg

# Create startup script
RUN printf '#!/bin/bash\n\
echo "🚀 Starting MTG Proxy..."\n\
echo "========================"\n\
SECRET=${SECRET:-$(openssl rand -hex 16)}\n\
PORT=${PORT:-443}\n\
echo "✅ Configuration:"\n\
echo "   Port: $PORT"\n\
echo "   Secret: $SECRET"\n\
echo ""\n\
echo "📱 Add to Telegram:"\n\
echo "   Server: [YOUR_DOMAIN]"\n\
echo "   Port: $PORT"\n\
echo "   Secret: $SECRET"\n\
echo "========================"\n\
printf "secret = \\"$SECRET\\"\\nbind-to = \\"0.0.0.0:$PORT\\"" > /tmp/mtg.toml\n\
echo "🔄 Starting MTG..."\n\
exec /usr/bin/mtg run /tmp/mtg.toml\n' > /start.sh && chmod +x /start.sh

ENV PORT=443
ENV SECRET=""

EXPOSE $PORT

CMD ["/start.sh"] 