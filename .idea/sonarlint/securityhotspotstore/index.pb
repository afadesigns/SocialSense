dashboard/
├── core/
│   ├── settings/
│   │   ├── __init__.py
│   │   ├── base.py
│   │   ├── development.py
│   │   └── production.py
│   ├── urls/
│   │   ├── __init__.py
│   │   └── include.py
│   ├── wsgi.py
│   └── asgi.py
│   └── __init__.py
├── home/
│   ├── models.py
│   ├── admin.py
│   ├── urls.py
│   ├── views.py
│   ├── apps.py
│   └── services.py
│   └── __init__.py
├── .env
├── .gitignore
├── requirements.txt
├── docker-compose.yml
├── Dockerfile
└── manage.py


# dashboard/core/settings/base.py

import os

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/3.2/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.environ.get('DJANGO_SECRET_KEY', 'your-secret-key')

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = os.environ.get('DJANGO_DEBUG', 'True') == 'True'

ALLOWED_HOSTS = []

# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django
