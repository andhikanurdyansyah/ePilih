# Setup Cloudinary for Railway Deployment

Untuk mengatasi masalah logo upload yang hilang di Railway (karena ephemeral filesystem), kita menggunakan Cloudinary sebagai cloud storage.

## Langkah Setup:

### 1. Daftar ke Cloudinary (GRATIS)
- Kunjungi: https://cloudinary.com/users/register/free
- Daftar dengan email Anda
- Setelah login, pergi ke Dashboard

### 2. Ambil Kredensial Cloudinary
Di dashboard Cloudinary, Anda akan melihat:
- Cloud Name: `your-cloud-name`
- API Key: `123456789012345`
- API Secret: `abcdefghijklmnopqrstuvwxyz123456`

### 3. Tambahkan Environment Variables di Railway
Masuk ke Railway project Anda dan tambahkan variables berikut:

```
CLOUDINARY_CLOUD_NAME=your-cloud-name
CLOUDINARY_API_KEY=123456789012345
CLOUDINARY_API_SECRET=abcdefghijklmnopqrstuvwxyz123456
```

### 4. Deploy Ulang
Setelah menambahkan environment variables, Railway akan otomatis deploy ulang.

## Penjelasan Masalah:
- Railway menggunakan "ephemeral filesystem" - file yang di-upload akan hilang saat container restart
- Cloudinary menyimpan file di cloud, jadi file akan persistent
- Gratis sampai 25GB storage dan 25GB bandwidth per bulan

## Testing:
Setelah setup:
1. Upload logo di admin panel
2. Refresh halaman - logo akan tetap muncul
3. File akan disimpan di Cloudinary, bukan di Railway filesystem
