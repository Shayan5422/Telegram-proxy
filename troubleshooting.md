# 🔧 راهنمای عیب‌یابی پروکسی تلگرام

## ❌ مشکلات رایج و راه‌حل‌ها

### 1. پروکسی وصل نمی‌شود

#### علل احتمالی:
- ❌ Space هنوز آماده نشده
- ❌ اطلاعات اشتباه وارد شده  
- ❌ مشکل شبکه محلی
- ❌ فیلترینگ اینترنت

#### راه‌حل‌ها:

**مرحله 1: بررسی وضعیت Space**
```bash
# وضعیت Space را بررسی کنید:
- Status باید "Running" باشد
- Build logs را چک کنید
- اگر خطا دارد، Space را restart کنید
```

**مرحله 2: بررسی اطلاعات**
```
✅ آدرس سرور: بدون https:// و بدون /
   درست: your-space.hf.space
   غلط: https://your-space.hf.space/

✅ پورت: حتماً 8080
   درست: 8080
   غلط: 443, 7860, 80

✅ Secret: کپی دقیق
   درست: dd1234567890abcdef...
   غلط: 1234567890abcdef... (بدون dd)
```

**مرحله 3: تست شبکه**
```bash
# WiFi را امتحان کنید
# داده موبایل را تست کنید  
# VPN‌های دیگر را خاموش کنید
# DNS را تغییر دهید (8.8.8.8, 1.1.1.1)
```

### 2. Space build نمی‌شود

#### راه‌حل‌ها:
1. **فایل Dockerfile را بررسی کنید**
2. **Logs را چک کنید**
3. **Space را rebuild کنید**
4. **از Dockerfile.simple2 استفاده کنید:**

```dockerfile
# محتوای Dockerfile را با این جایگزین کنید:
FROM telegrammessenger/proxy:latest
EXPOSE 7860 8080
CMD ["python3", "-m", "http.server", "7860"]
```

### 3. راه‌حل‌های جایگزین

#### گزینه 1: استفاده از Dockerfile ساده
```bash
# فایل Dockerfile فعلی را به نام Dockerfile.backup کپی کنید
cp Dockerfile Dockerfile.backup

# محتوای Dockerfile.simple2 را به Dockerfile کپی کنید
cp Dockerfile.simple2 Dockerfile
```

#### گزینه 2: پلتفرم‌های جایگزین
- **Railway.app** (رایگان)
- **Render.com** (رایگان) 
- **Fly.io** (رایگان با کارت)
- **Heroku** (پولی)

#### گزینه 3: پروکسی‌های آماده
- ProxyBot تلگرام
- MTProxy رایگان آنلاین
- VPN‌های رایگان

### 4. تست پروکسی

#### روش‌های تست:
```bash
# 1. تست از طریق مرورگر
https://your-space.hf.space

# 2. تست با curl
curl -I https://your-space.hf.space

# 3. تست پورت
telnet your-space.hf.space 8080
```

### 5. خطاهای رایج

#### "Connection refused"
- Space خاموش است
- پورت اشتباه است
- فایروال مشکل دارد

#### "Invalid secret"
- Secret اشتباه کپی شده
- dd در ابتدای secret نیست
- کاراکتر اضافی در secret

#### "Server not found"
- آدرس اشتباه است
- DNS مشکل دارد
- اینترنت قطع است

### 6. کمک‌های اضافی

#### لینک‌های مفید:
- [Telegram Proxy Settings](https://telegram.org/blog/proxy-support)
- [MTProxy Official](https://github.com/TelegramMessenger/MTProxy)
- [Hugging Face Docs](https://huggingface.co/docs/hub/spaces)

#### پشتیبانی:
- ایشوها در GitHub
- کامیونتی Hugging Face
- فروم‌های تلگرام

---

## 🚀 راه‌حل سریع

اگر هیچ‌کدام کار نکرد:

1. **Space جدید بسازید**
2. **از Dockerfile.simple2 استفاده کنید**  
3. **10 دقیقه صبر کنید**
4. **دوباره تست کنید**

موفق باشید! 🎉 