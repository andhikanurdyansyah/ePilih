# Aplikasi E-Voting berbasis Website

Sebuah sistem pemilihan online yang memanfaatkan teknologi web dan dikembangkan menggunakan framework `Django`. Aplikasi ini dapat digunakan untuk memudahkan proses pemilihan secara elektronik. Dalam aplikasi e-voting ini, terdapat beberapa fitur seperti pembuatan daftar pemilih, pemilihan, perhitungan suara, dan pengumuman hasil pemilihan. Pengguna dapat melakukan voting sebagai pemilih dan memilih calon dengan mudah melalui antarmuka web yang user-friendly. Selain itu, aplikasi ini juga memberikan kemudahan bagi para pengelola pemilihan dalam mengelola data pemilih dan hasil pemilihan, sehingga dapat mempercepat proses pengolahan data.

### Requirement :
`Python 3.x.x`

### Rekomendasi :
`Python 3.7.9`

### Mode
Untuk konfigurasi web ini ada 2 mode yaitu : 
1. Development (Proses di server lokal)
	- Jika masih dalam server lokal, ubah `DEBUG` menjadi `True` pada file `settings.py`. Maka akan menggunakan konfigurasi pada file `dev.py`.
	- Database otomatis menggunakan `db.sqlite3` SQLite yang sudah ada di dalam source code.

2. Production (Proses di server hosting)
	- Jika ingin menjalankan di server hosting, ubah `DEBUG` menjadi `False` pada file `settings.py`. Maka akan menggunakan konfigurasi pada file `prod.py`.
	- Tambahkan library `mysqlclient` untuk menangani database yang menggunakan mysql. Install library dengan terminal `pip install mysqlclient`
	- Anda dapat mengubah pengaturan database dan penyimpanan file dalam file `prod.py`.
	
to run 
python manage.py runserver 0.0.0.0:8000