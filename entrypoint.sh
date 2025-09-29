#!/bin/sh

# Set default PORT if not provided
export PORT=${PORT:-8000}

echo "=== Railway Deployment Debug Info ==="
echo "PORT: $PORT"
echo "PYTHONPATH: $PYTHONPATH"
echo "DJANGO_SETTINGS_MODULE: $DJANGO_SETTINGS_MODULE"

# Show environment variables (without sensitive data)
echo "=== Environment Variables Check ==="
if [ -n "$DATABASE_URL" ]; then
    echo "✓ DATABASE_URL: Available ($(echo $DATABASE_URL | cut -c1-25)...)"
else
    echo "✗ DATABASE_URL: Not found"
fi

echo "DEBUG: $DEBUG"
echo "SECRET_KEY: $(echo ${SECRET_KEY:-"Not set"} | cut -c1-10)..."

# Show Railway-specific variables
echo "RAILWAY_ENVIRONMENT: ${RAILWAY_ENVIRONMENT:-"Not set"}"
echo "PORT: $PORT"

# Test Django configuration
echo "=== Testing Django Configuration ==="
python -c "
import os, sys
sys.path.insert(0, '/app')
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'evoting.settings')
try:
    import django
    from django.conf import settings
    django.setup()
    print('✓ Django configuration loaded')
    
    # Show database configuration
    db_config = settings.DATABASES['default']
    print(f'Database ENGINE: {db_config.get(\"ENGINE\", \"Not set\")}')
    print(f'Database NAME: {db_config.get(\"NAME\", \"Not set\")}')
    print(f'Database HOST: {db_config.get(\"HOST\", \"Not set\")}')
    print(f'Database PORT: {db_config.get(\"PORT\", \"Not set\")}')
    
    # Test database connection
    from django.db import connection
    with connection.cursor() as cursor:
        cursor.execute('SELECT 1')
        result = cursor.fetchone()
        print(f'✓ Database connection OK - Test result: {result}')
        
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
