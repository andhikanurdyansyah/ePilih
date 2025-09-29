#!/bin/sh

# Set default PORT if not provided
export PORT=${PORT:-8000}

echo "=== Railway Deployment Debug Info ==="
echo "PORT: $PORT"
echo "PYTHONPATH: $PYTHONPATH"
echo "DJANGO_SETTINGS_MODULE: $DJANGO_SETTINGS_MODULE"

# Show environment variables (without sensitive data)
if [ -n "$DATABASE_URL" ]; then
    echo "DATABASE_URL: Available ($(echo $DATABASE_URL | cut -c1-20)...)"
else
    echo "DATABASE_URL: Not found"
fi

# Test Django configuration
echo "=== Testing Django Configuration ==="
python -c "
import os, sys
sys.path.insert(0, '/app')
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'evoting.settings')
try:
    import django
    django.setup()
    print('✓ Django configuration OK')
    
    # Test database connection
    from django.db import connection
    with connection.cursor() as cursor:
        cursor.execute('SELECT 1')
        print('✓ Database connection OK')
        
except Exception as e:
    print(f'✗ Django/Database error: {e}')
    import traceback
    traceback.print_exc()
"

# Create necessary directories
mkdir -p /app/staticfiles /app/media /app/website/media/logo /app/website/media/photos

# Run migrations with verbose output
echo "=== Running Database Migrations ==="
python manage.py migrate --noinput --verbosity=2 || {
    echo "⚠️ Migration had issues, checking database state..."
    python manage.py showmigrations
}

# Initialize application data
echo "=== Initializing Application Data ==="
python manage.py init_app || {
    echo "⚠️ App initialization had issues, continuing..."
}

# Collect static files
echo "=== Collecting Static Files ==="
python manage.py collectstatic --noinput --verbosity=2 || {
    echo "⚠️ Static collection had issues, continuing..."
}

# Test if the application can start
echo "=== Testing Django Server ==="
python manage.py check --deploy || {
    echo "⚠️ Django deployment checks found issues"
}

# Create a simple test view
echo "=== Creating Health Check ==="
python -c "
from django.http import HttpResponse
from django.conf import settings
import os
print('Django settings loaded successfully')
print('ALLOWED_HOSTS:', getattr(settings, 'ALLOWED_HOSTS', 'Not set'))
print('DEBUG:', getattr(settings, 'DEBUG', 'Not set'))
"

echo "=== Starting Gunicorn Server ==="
echo "Binding to 0.0.0.0:$PORT"
exec gunicorn evoting.wsgi:application \
    --bind 0.0.0.0:$PORT \
    --workers 2 \
    --threads 2 \
    --timeout 60 \
    --keep-alive 5 \
    --max-requests 1000 \
    --preload \
    --access-logfile - \
    --error-logfile - \
    --log-level info
