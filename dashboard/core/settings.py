# Import necessary modules
import os
import random
import string
import sys  # Added for integrating Instagrapi
from pathlib import Path

from dotenv import load_dotenv

load_dotenv()  # take environment variables from .env.

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/4.1/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.environ.get("SECRET_KEY")
if not SECRET_KEY:
    SECRET_KEY = "".join(random.choice(string.ascii_lowercase) for _ in range(32))

# Render Deployment Code
DEBUG = "RENDER" not in os.environ

# HOSTs List
ALLOWED_HOSTS = ["localhost", "127.0.0.1"]

# Add here your deployment HOSTS
CSRF_TRUSTED_ORIGINS = [
    "http://localhost:8000",
    "http://localhost:5085",
    "http://127.0.0.1:8000",
    "http://127.0.0.1:5085",
]

RENDER_EXTERNAL_HOSTNAME = os.environ.get("RENDER_EXTERNAL_HOSTNAME")
if RENDER_EXTERNAL_HOSTNAME:
    ALLOWED_HOSTS.append(RENDER_EXTERNAL_HOSTNAME)

# Add Instagram API domain to trusted hosts
API_DOMAIN = "i.instagram.com"
ALLOWED_HOSTS.append(API_DOMAIN)

# Add the path to the Instagrapi library to the PYTHONPATH
INSTAGRAM_SERVICE_DIR = os.path.join(BASE_DIR, "services", "instagram")
sys.path.append(INSTAGRAM_SERVICE_DIR)

# Application definition

INSTALLED_APPS = [
    "admin_black_pro.apps.AdminBlackProConfig",
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "home",  # This is correct if 'home' is your Django app
    # Remove "InstagramClient" if it's not an actual app
]


MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "whitenoise.middleware.WhiteNoiseMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "core.urls"

HOME_TEMPLATES = os.path.join(BASE_DIR, "home", "templates")

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [os.path.join(BASE_DIR, "home", "templates")],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "core.wsgi.application"

# Database
# https://docs.djangoproject.com/en/4.1/ref/settings/#databases

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": "postgres",
        "USER": "postgres",
        "PASSWORD": "Sierra16",
        "HOST": "localhost",
        "PORT": "5432",
    }
}

# Password validation
# https://docs.djangoproject.com/en/4.1/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.MinimumLengthValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.CommonPasswordValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.NumericPasswordValidator",
    },
]

# Internationalization
# https://docs.djangoproject.com/en/4.1/topics/i18n/

LANGUAGE_CODE = "en-us"

TIME_ZONE = "UTC"

USE_I18N = True

USE_TZ = True

# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/4.1/howto/static-files/

STATIC_URL = "/static/"
STATIC_ROOT = os.path.join(BASE_DIR, "staticfiles")

STATICFILES_DIRS = (os.path.join(BASE_DIR, "static"),)

# Default primary key field type
# https://docs.djangoproject.com/en/4.1/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

LOGIN_REDIRECT_URL = "/"
EMAIL_BACKEND = "django.core.mail.backends.console.EmailBackend"

# Configure Instagram API Client settings here
INSTAGRAM_API_SETTINGS = {
    "API_DOMAIN": API_DOMAIN,
    "USER_AGENT_BASE": (
        "Instagram {app_version} "
        "Android ({android_version}/{android_release}; "
        "{dpi}; {resolution}; {manufacturer}; "
        "{model}; {device}; {cpu}; {locale}; {version_code})"
    ),
    "SOFTWARE": "{model}-user+{android_release}+OPR1.170623.032+V10.2.3.0.OAGMIXM+release-keys",
    # Add other settings here as needed
}

# Import Instagram API Client
