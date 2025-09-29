import os
import dj_database_url

ALLOWED_HOSTS = ['*']

# Railway Database Configuration
if 'DATABASE_URL' in os.environ:
    DATABASES = {
        'default': dj_database_url.parse(os.environ.get('DATABASE_URL'))
    }
else:
    # Fallback database config
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

# Static files configuration - menggunakan path yang sama dengan settings.py
STATIC_ROOT = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'staticfiles')
MEDIA_ROOT = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'media')
