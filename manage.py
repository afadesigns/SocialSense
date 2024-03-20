import os
import sys


def main():
    """
    Run administrative tasks using Django's management scripts.

    This function sets the default Django settings module and then executes the command line provided.
    """
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "socialsense.settings")

    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError(
            "Couldn't import Django. Are you sure it's installed and "
            "available on your PYTHONPATH environment variable? Did you "
            "forget to activate a virtual environment?"
        ) from exc

    execute_from_command_line(sys.argv)
