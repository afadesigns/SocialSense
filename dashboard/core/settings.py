# C:\Users\Andreas\Projects\SocialSense\dashboard\core\settings.py

import os
from pathlib import Path
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

BASE_DIR = Path(__file__).resolve().parent.parent

<<<<<<< HEAD
# Generate a random SECRET_KEY if not provided in environment
SECRET_KEY = os.getenv("SECRET_KEY")
if not SECRET_KEY:
    SECRET_KEY = "".join(random.choice(string.ascii_lowercase) for _ in range(32))
=======
# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/4.1/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.environ.get("SECRET_KEY") or "".join(
    random.choice(string.ascii_lowercase) for _ in range(32)
)
>>>>>>> 253105264d5cd49cfadfc83b0a7ab8b7f4f637c1

# Set DEBUG based on environment
DEBUG = "RENDER" not in os.environ

<<<<<<< HEAD
# Define ALLOWED_HOSTS
ALLOWED_HOSTS = ["localhost", "127.0.0.1"]

# Add RENDER_EXTERNAL_HOSTNAME if provided
RENDER_EXTERNAL_HOSTNAME = os.getenv("RENDER_EXTERNAL_HOSTNAME")
=======
LOGIN_REDIRECT_URL = "/"
LOGOUT_REDIRECT_URL = "/"

# HOSTs List
ALLOWED_HOSTS = ["localhost", "127.0.0.1"]

CSRF_TRUSTED_ORIGINS = [
    "http://localhost:8000",
    "http://localhost:5085",
    "http://127.0.0.1:8000",
    "http://127.0.0.1:5085",
]

RENDER_EXTERNAL_HOSTNAME = os.environ.get("RENDER_EXTERNAL_HOSTNAME")
>>>>>>> 253105264d5cd49cfadfc83b0a7ab8b7f4f637c1
if RENDER_EXTERNAL_HOSTNAME:
    ALLOWED_HOSTS.append(RENDER_EXTERNAL_HOSTNAME)

API_DOMAIN = "i.instagram.com"
ALLOWED_HOSTS.append(API_DOMAIN)

<<<<<<< HEAD
# Application definition
=======
AUTHENTICATION_BACKENDS = []

INSTAGRAM_CLIENT_ID = os.environ.get("INSTAGRAM_CLIENT_ID")

>>>>>>> 253105264d5cd49cfadfc83b0a7ab8b7f4f637c1
INSTALLED_APPS = [
    "admin_black_pro.apps.AdminBlackProConfig",
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
<<<<<<< HEAD
    "home",  # Assuming 'home' is a Django app
    # Remove "InstagramClient" if it's not an actual app
=======
    # This is correct if 'home' is your Django app
    "home",
    # Add this line if 'instagram_client' is your app
    "instagram_client",
>>>>>>> 253105264d5cd49cfadfc83b0a7ab8b7f4f637c1
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

<<<<<<< HEAD
# Database settings
=======
>>>>>>> 253105264d5cd49cfadfc83b0a7ab8b7f4f637c1
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": os.environ.get("DB_NAME", "postgres"),
        "USER": os.environ.get("DB_USER", "postgres"),
        "PASSWORD": os.environ.get("DB_PASSWORD", "Sierra16"),
        "HOST": os.environ.get("DB_HOST", "localhost"),
        "PORT": os.environ.get("DB_PORT", "5432"),
    }
}

<<<<<<< HEAD
# Password validation settings
=======
>>>>>>> 253105264d5cd49cfadfc83b0a7ab8b7f4f637c1
AUTH_PASSWORD_VALIDATORS = [
    {"NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator"},
    {"NAME": "django.contrib.auth.password_validation.MinimumLengthValidator"},
    {"NAME": "django.contrib.auth.password_validation.CommonPasswordValidator"},
    {"NAME": "django.contrib.auth.password_validation.NumericPasswordValidator"},
]

<<<<<<< HEAD
# Internationalization settings
=======
# Internationalization
>>>>>>> 253105264d5cd49cfadfc83b0a7ab8b7f4f637c1
LANGUAGE_CODE = "en-us"
TIME_ZONE = "UTC"
USE_I18N = True
USE_TZ = True

<<<<<<< HEAD
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
=======
# Static files (CSS, JavaScript, Images)
# https

STATIC_ROOT = os.path.join(BASE_DIR, "staticfiles")
>>>>>>> 253105264d5cd49cfadfc83b0a7ab8b7f4f637c1
