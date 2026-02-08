import os

SECRET_KEY = os.environ.get("DJANGO_SECRET_KEY", "unsafe-default-key")
ALLOWED_HOSTS = ["*"]  # Allow all hosts for ECS/ALB

INSTALLED_APPS = [
    'django.contrib.contenttypes',
    'django.contrib.auth',
]

MIDDLEWARE = [
    'django.middleware.common.CommonMiddleware',
]
