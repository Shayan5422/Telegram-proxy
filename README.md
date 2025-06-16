# Free Telegram MTProxy

This is a free Telegram MTProxy (MTProto proxy) that can be hosted on various free cloud platforms.

## What is MTProxy?

MTProxy is Telegram's official proxy protocol that allows you to access Telegram through a proxy server. This is useful for:
- Bypassing network restrictions
- Improving connection reliability
- Accessing Telegram in countries where it might be blocked

## Features

- **100% Free** - No cost to run on free tier platforms
- **Easy deployment** - One-click deploy options
- **Secure** - Uses Telegram's official MTProxy implementation
- **Auto-scaling** - Scales based on usage
- **No logs** - Privacy-focused setup

## Quick Deploy Options

### Option 1: Railway (Recommended - True Free Tier)

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template)

1. Click the Railway button above
2. Connect your GitHub account
3. Fork this repository 
4. Deploy the app
5. Check deployment logs for your proxy details

### Option 2: Manual Railway Deployment

1. Go to [Railway.app](https://railway.app)
2. Sign up with GitHub (free)
3. Create a new project
4. Connect this GitHub repository
5. Deploy automatically

### Option 3: Render.com

1. Go to [Render.com](https://render.com)
2. Sign up (free)
3. Create new Web Service
4. Connect this GitHub repository
5. Use these settings:
   - Build Command: (leave empty)
   - Start Command: `/start.sh`

## After Deployment

1. **Check the deployment logs** to find your proxy details
2. Look for output like:
   ```
   Port: 443
   Secret: dd1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o
   Server: your-app-name.railway.app
   ```

3. **Add to Telegram**:
   - Open Telegram
   - Go to Settings → Data and Storage → Proxy Settings
   - Add Proxy → MTProto
   - Enter your server details

## Connection Details

- **Protocol**: MTProto
- **Server**: Your deployment URL (e.g., `your-app.railway.app`)
- **Port**: `443` (or the port shown in logs)
- **Secret**: The secret shown in deployment logs (starts with `dd`)

## Alternative Free Hosting Options

If Railway doesn't work for you, try these other free platforms:

1. **Render.com** - Free tier with 750 hours/month
2. **Heroku** - Has discontinued free tier
3. **Google Cloud Run** - Generous free tier
4. **Oracle Cloud** - Always-free tier available

## Local Testing

To test locally:

```bash
docker build -t mtproxy .
docker run -p 443:443 -p 8888:8888 mtproxy
```

## Security Notes

- This proxy uses Telegram's official MTProxy implementation
- All traffic is encrypted using Telegram's MTProto protocol
- The proxy cannot decrypt or read your messages
- No logs are stored by default

## Troubleshooting

**Common Issues:**

1. **Connection failed**: Check if the service is running in your dashboard
2. **Port issues**: Some networks block port 443, try port 80 or 8080
3. **Secret issues**: Make sure to copy the complete secret including the `dd` prefix

**Need help?** Check the deployment logs in your hosting platform's dashboard.

## Legal Notice

This proxy is for educational and legitimate use only. Please comply with your local laws and Telegram's Terms of Service. 