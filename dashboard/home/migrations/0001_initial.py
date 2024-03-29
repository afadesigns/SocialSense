# Generated by Django 5.0.3 on 2024-03-08 21:09

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = []

    operations = [
        # Model for storing analytics data
        migrations.CreateModel(
            name="AnalyticsData",
            fields=[
                ("analytics_id", models.AutoField(primary_key=True, serialize=False)),
                ("data", models.JSONField()),
                ("processed_at", models.DateTimeField(auto_now_add=True)),
            ],
            options={
                "db_table": "analytics_data",
            },
        ),

        # Model for storing log entries
        migrations.CreateModel(
            name="LogEntry",
            fields=[
                ("id", models.AutoField(primary_key=True, serialize=False)),
                ("timestamp", models.DateTimeField(auto_now_add=True)),
                ("log_level", models.CharField(max_length=255)),
                ("message", models.TextField()),
                ("log_data", models.JSONField()),
            ],
            options={
                "db_table": "log_entries",
            },
        ),

        # Model for storing public reporting data
        migrations.CreateModel(
            name="PublicReportingData",
            fields=[
                ("report_id", models.AutoField(primary_key=True, serialize=False)),
                ("data", models.JSONField()),
                ("created_at", models.DateTimeField(auto_now_add=True)),
            ],
            options={
                "db_table": "public_reporting_data",
            },
        ),

        # Model for storing internal reporting data
        migrations.CreateModel(
            name="InternalReportingData",
            fields=[
                ("report_id", models.AutoField(primary_key=True, serialize=False)),
                ("data", models.JSONField()),
                ("created_at", models.DateTimeField(auto_now_add=True)),
            ],
            options={
                "db_table": "reporting_data",
            },
        ),
    ]
