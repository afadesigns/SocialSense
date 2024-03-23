# dashboard/home/models.py

from django.contrib.auth.models import User
from django.db import models


class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="profile")
    instagram_username = models.CharField(max_length=255, blank=True, null=True)
    instagram_password = models.CharField(max_length=255, blank=True, null=True)

    def __str__(self):
        return self.user.username + "'s profile"


# Signal to create or update the user's profile
from django.db.models.signals import post_save
from django.dispatch import receiver


@receiver(post_save, sender=User)
def create_or_update_user_profile(sender, instance, created, **kwargs):
    if created:
        UserProfile.objects.create(user=instance)
    instance.profile.save()


class AnalyticsData(models.Model):
    analytics_id = models.AutoField(primary_key=True)
    data = models.JSONField()
    processed_at = models.DateTimeField()

    class Meta:
        db_table = "analytics_data"
        managed = False


class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=150)

    class Meta:
        db_table = "auth_group"
        managed = False


class AuthGroupPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    group = models.ForeignKey("AuthGroup", on_delete=models.DO_NOTHING)
    permission = models.ForeignKey("AuthPermission", on_delete=models.DO_NOTHING)

    class Meta:
        db_table = "auth_group_permissions"
        unique_together = (("group", "permission"),)
        managed = False


class AuthPermission(models.Model):
    name = models.CharField(max_length=255)
    content_type = models.ForeignKey("DjangoContentType", on_delete=models.DO_NOTHING)
    codename = models.CharField(max_length=100)

    class Meta:
        db_table = "auth_permission"
        unique_together = (("content_type", "codename"),)
        managed = False


class AuthUser(models.Model):
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(blank=True, null=True)
    is_superuser = models.BooleanField()
    username = models.CharField(unique=True, max_length=150)
    first_name = models.CharField(max_length=150)
    last_name = models.CharField(max_length=150)
    email = models.CharField(max_length=254)
    is_staff = models.BooleanField()
    is_active = models.BooleanField()
    date_joined = models.DateTimeField()

    class Meta:
        db_table = "auth_user"
        managed = False


class AuthUserGroups(models.Model):
    user = models.ForeignKey("AuthUser", on_delete=models.DO_NOTHING)
    group = models.ForeignKey("AuthGroup", on_delete=models.DO_NOTHING)

    class Meta:
        db_table = "auth_user_groups"
        unique_together = (("user", "group"),)
        managed = False


class AuthUserUserPermissions(models.Model):
    user = models.ForeignKey("AuthUser", on_delete=models.DO_NOTHING)
    permission = models.ForeignKey("AuthPermission", on_delete=models.DO_NOTHING)

    class Meta:
        db_table = "auth_user_user_permissions"
        unique_together = (("user", "permission"),)
        managed = False


class DjangoAdminLog(models.Model):
    action_time = models.DateTimeField()
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.SmallIntegerField()
    change_message = models.TextField()
    content_type = models.ForeignKey(
        "DjangoContentType", on_delete=models.DO_NOTHING, blank=True, null=True
    )
    user = models.ForeignKey("AuthUser", on_delete=models.DO_NOTHING)

    class Meta:
        db_table = "django_admin_log"
        managed = False


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        db_table = "django_content_type"
        unique_together = (("app_label", "model"),)
        managed = False


class DjangoMigrations(models.Model):
    id = models.BigAutoField(primary_key=True)
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        db_table = "django_migrations"
        managed = False


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField()
    expire_date = models.DateTimeField()

    class Meta:
        db_table = "django_session"
        managed = False


class HomeClient(models.Model):
    id = models.BigAutoField(primary_key=True)
    proxy = models.CharField(max_length=255)
    settings = models.JSONField()
    delay_range = models.JSONField()
    logger = models.CharField(max_length=255)

    class Meta:
        db_table = "home_client"
        managed = False


class HomeInstagramclient(models.Model):
    client_ptr = models.OneToOneField(
        "HomeClient", on_delete=models.DO_NOTHING, primary_key=True
    )

    class Meta:
        db_table = "home_instagramclient"
        managed = False


class LogEntries(models.Model):
    timestamp = models.DateTimeField()
    log_level = models.CharField(max_length=255)
    message = models.TextField()
    log_data = models.JSONField()

    class Meta:
        db_table = "log_entries"
        managed = False


class PublicReportingData(models.Model):
    report_id = models.AutoField(primary_key=True)
    data = models.JSONField()
    created_at = models.DateTimeField()

    class Meta:
        db_table = "public_reporting_data"
        managed = False


class ReportingData(models.Model):
    report_id = models.AutoField(primary_key=True)
    data = models.JSONField()
    created_at = models.DateTimeField()

    class Meta:
        db_table = "reporting_data"
        managed = False
