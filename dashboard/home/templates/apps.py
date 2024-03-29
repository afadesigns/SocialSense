from django.apps import AppConfig

class AdminBlackProConfig(AppConfig):
    """
    Configuration for the Admin Black Pro app.
    """
    default_auto_field = "django.db.models.BigAutoField"
    name = "admin_black_pro"
    verbose_name = "Admin Black Pro"

    def ready(self):
        """
        Optional: Override this method to perform any app-specific initialization after the app is loaded.
        """
        pass
