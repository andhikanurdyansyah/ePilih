from . import settings

ALLOWED_HOSTS = ['*']

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': 'db.sqlite3',
    }
}

STATIC_ROOT = settings.BASE_DIR / "website/static/"
MEDIA_ROOT = settings.BASE_DIR / "website/media/"