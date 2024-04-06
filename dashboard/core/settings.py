# C:\Users\Andreas\Projects\SocialSense\dashboard\core\settings.py

import os
import random
import string
from pathlib import Path

from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent

# Generate a random SECRET_KEY if not provided in environment
SECRET_KEY = os.getenv("SECRET_KEY")
if not SECRET_KEY:
    SECRET_KEY = "".join(random.choice(string.ascii_lowercase) for _ in range(32))

# Set DEBUG based on environment
DEBUG = "RENDER" not in os.environ

# Define ALLOWED_HOSTS
ALLOWED_HOSTS = ["localhost", "127.0.0.1"]

# Add RENDER_EXTERNAL_HOSTNAME if provided
RENDER_EXTERNAL_HOSTNAME = os.getenv("RENDER_EXTERNAL_HOSTNAME")
if RENDER_EXTERNAL_HOSTNAME:
    ALLOWED_HOSTS.append(RENDER_EXTERNAL_HOSTNAME)

# Add Instagram API domain to trusted hosts
API_DOMAIN = "i.instagram.com"
ALLOWED_HOSTS.append(API_DOMAIN)

# Application definition
INSTALLED_APPS = [
    "admin_black_pro.apps.AdminBlackProConfig",
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "home",  # Assuming 'home' is a Django app
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

# Define template directories
HOME_TEMPLATES = os.path.join(BASE_DIR, "home", "templates")

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [HOME_TEMPLATES],
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

# Database settings
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

# Password validation settings
AUTH_PASSWORD_VALIDATORS = [
    {"NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator"},
    {"NAME": "django.contrib.auth.password_validation.MinimumLengthValidator"},
    {"NAME": "django.contrib.auth.password_validation.CommonPasswordValidator"},
    {"NAME": "django.contrib.auth.password_validation.NumericPasswordValidator"},
]

# Internationalization settings
LANGUAGE_CODE = "en-us"
TIME_ZONE = "UTC"
USE_I18N = True
USE_TZ = True

# Static files settings
STATIC_URL = "/static/"
STATIC_ROOT = os.path.join(BASE_DIR, "staticfiles")
STATICFILES_DIRS = (os.path.join(BASE_DIR, "static"),)

# Default primary key field type
DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

# Login redirect URL
LOGIN_REDIRECT_URL = "/"

# Email backend
EMAIL_BACKEND = "django.core.mail.backends.console.EmailBackend"

# Instagram API Client settings
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

# Instagram credentials
INSTAGRAM_USERNAME = os.getenv("INSTAGRAM_USERNAME")
INSTAGRAM_PASSWORD = os.getenv("INSTAGRAM_PASSWORD")
