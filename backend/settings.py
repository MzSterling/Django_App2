import os

SECRET_KEY = os.environ.get("DJANGO_SECRET_KEY", "unsafe-default-key")
ALLOWED_HOSTS = ["*"]

INSTALLED_APPS = [
    'django.contrib.contenttypes',
    'django.contrib.auth',
]

MIDDLEWARE = [
    'django.middleware.common.CommonMiddleware',
]

ROOT_URLCONF = 'backend.urls'  # Make sure this points to your urls.py

# Disable database connections
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.dummy'
    }
}
