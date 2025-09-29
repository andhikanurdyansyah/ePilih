from . import settings
import os  # Pastikan ini ada untuk membaca variabel lingkungan (ENV)

ALLOWED_HOSTS = ['*']

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',  # Ganti dari mysql ke postgresql
        'NAME': os.environ.get('DB_NAME', 'epilih'),
        'USER': os.environ.get('DB_USER', 'epilihuser'),
        'PASSWORD': os.environ.get('DB_PASS', 'epilihpass'),
        'HOST': os.environ.get('DB_HOST', 'db'),  # Gunakan service name dari docker-compose
        'PORT': os.environ.get('DB_PORT', '5432'),
    }
}

# Path statis/media dalam container
STATIC_ROOT = '/app/static/'
MEDIA_ROOT = '/app/media/'
