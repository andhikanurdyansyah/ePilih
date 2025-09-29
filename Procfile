web: python manage.py migrate --noinput && python manage.py collectstatic --noinput && gunicorn evoting.wsgi:application --host 0.0.0.0 --port $PORT
