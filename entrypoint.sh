#!/bin/sh

echo "Menunggu database siap..."

# Tunggu PostgreSQL siap (tanpa netcat)
until python -c "
import socket
import time
s = socket.socket()
while True:
    try:
        s.connect(('$DB_HOST', 5432))
        break
    except socket.error:
        time.sleep(1)
"; do
  echo "Menunggu koneksi ke PostgreSQL di $DB_HOST:5432..."
  sleep 1
done

echo "Database siap, menjalankan migrasi..."

python manage.py migrate --noinput
python manage.py collectstatic --noinput

echo "Menjalankan server gunicorn..."
exec gunicorn evoting.wsgi:application --bind 0.0.0.0:8000
