#!/bin/sh

# Set default PORT if not provided
export PORT=${PORT:-8000}

echo "Starting Railway deployment..."
echo "PORT: $PORT"

# Jika menggunakan Railway, DATABASE_URL akan tersedia
if [ -n "$DATABASE_URL" ]; then
    echo "Railway PostgreSQL detected"
else
    echo "No DATABASE_URL found - using fallback configuration"
fi

echo "Running database migrations..."
python manage.py migrate --noinput || {
    echo "Migration failed, but continuing..."
}

echo "Collecting static files..."
python manage.py collectstatic --noinput || {
    echo "Static collection failed, but continuing..."
}

echo "Starting Gunicorn server on port $PORT..."
exec gunicorn evoting.wsgi:application \
    --bind 0.0.0.0:$PORT \
    --workers 2 \
    --timeout 120 \
    --keep-alive 5 \
    --access-logfile - \
    --error-logfile -
