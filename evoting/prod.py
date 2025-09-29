import os
import dj_database_url

ALLOWED_HOSTS = ['*']

# Always use DATABASE_URL if available (Railway provides this)
if 'DATABASE_URL' in os.environ:
    DATABASES = {
        'default': dj_database_url.parse(
            os.environ.get('DATABASE_URL'),
            conn_max_age=600,
            conn_health_checks=True,
        )
    }
    print(f"prod.py: Using DATABASE_URL")
else:
    # Fallback to individual environment variables
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.postgresql',
            'NAME': os.environ.get('DB_NAME', 'epilih'),
            'USER': os.environ.get('DB_USER', 'epilihuser'),
            'PASSWORD': os.environ.get('DB_PASS', 'epilihpass'),
            'HOST': os.environ.get('DB_HOST', 'localhost'),
            'PORT': os.environ.get('DB_PORT', '5432'),
        }
    }
    print(f"prod.py: Using individual env vars - HOST: {os.environ.get('DB_HOST', 'localhost')}")

# Static files configuration - menggunakan path yang sama dengan settings.py
STATIC_ROOT = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'staticfiles')
MEDIA_ROOT = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'media')
