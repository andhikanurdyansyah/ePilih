# 🚀 Panduan Deploy Django E-Voting ke Railway

## Langkah-langkah Deploy:

### 1. Persiapan Repository
- Pastikan semua file sudah di-commit ke Git
- Push ke GitHub repository

### 2. Setup Railway Account
1. Kunjungi [railway.app](https://railway.app)
2. Sign up dengan GitHub account
3. Verifikasi email (tidak perlu kartu kredit)

### 3. Deploy ke Railway
1. **New Project** → **Deploy from GitHub repo**
2. Pilih repository `ePilih` Anda
3. Railway akan otomatis detect Django dan PostgreSQL

### 4. Tambahkan PostgreSQL Database
1. Di Railway dashboard → **+ New** → **Database** → **PostgreSQL**
2. Database akan auto-connect ke aplikasi Anda

### 5. Set Environment Variables
Di Railway dashboard → **Variables** tab, tambahkan:
```
SECRET_KEY=wt*)4wz$w0%fliulzn!zzn0=%#gzv!7*fm*e-lu8v=n*(m10q@
DEBUG=False
```

### 6. Deploy & Test
1. Railway akan otomatis deploy setelah setiap Git push
2. Tunggu build selesai (~3-5 menit)
3. Klik URL yang diberikan Railway untuk test aplikasi

## 🔧 File yang Sudah Disiapkan:

- ✅ `railway.json` - Konfigurasi Railway
- ✅ `Procfile` - Command startup alternatif  
- ✅ `requirements.txt` - Updated dengan dependencies
- ✅ `runtime.txt` - Versi Python
- ✅ `settings.py` - Production-ready configuration
- ✅ `.env.example` - Template environment variables

## 🐛 Troubleshooting:

**Build gagal?**
- Cek logs di Railway dashboard
- Pastikan `requirements.txt` valid

**Database error?**
- Pastikan PostgreSQL service sudah running
- Cek connection di Variables tab

**Static files tidak load?**
- Railway akan handle static files via WhiteNoise
- Collectstatic otomatis run saat deploy

## 📊 Limitasi Free Tier Railway:
- $5 credit gratis per bulan
- Aplikasi sleep setelah idle
- 512MB RAM limit
- Cukup untuk development/demo

## 🔄 Update Aplikasi:
Setiap `git push` ke branch main akan trigger auto-deployment.

## 🌐 Custom Domain:
Upgrade ke Pro plan untuk custom domain.
