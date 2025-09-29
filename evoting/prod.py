import os
from .db_utils import get_database_config

ALLOWED_HOSTS = ['*']

# Use custom database configuration
DATABASES = {
    'default': get_database_config()
}

# Static files configuration - menggunakan path yang sama dengan settings.py
STATIC_ROOT = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'staticfiles')
MEDIA_ROOT = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'media')
