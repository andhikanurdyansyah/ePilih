from . import settings

ALLOWED_HOSTS = ['*']

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'railway',
        'USER': 'postgres', 
        'PASSWORD': 'PhIdtlVyrJSBYtqYnRLrBznzppdWpKdI',
        'PORT': 5432,
        'HOST': 'postgres.railway.internal'
    }
}

STATIC_ROOT = '/home/username/direktoi-domain/static/'
MEDIA_ROOT = '/home/username/direktoi-domain/media/'
