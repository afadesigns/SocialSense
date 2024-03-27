# C:\Users\Andreas\Projects\SocialSense\dashboard\home\admin.py

from django.contrib import admin


# Define model admin classes here


class LogEntriesAdmin(admin.ModelAdmin):
    list_display = ("id", "timestamp", "log_level")
    list_filter = ("log_level",)
    search_fields = ("message",)
    date_hierarchy = "timestamp"


class PublicReportingDataAdmin(admin.ModelAdmin):
    list_display = ("report_id", "created_at")
    search_fields = ("report_id",)


class ReportingDataAdmin(admin.ModelAdmin):
    list_display = ("report_id", "created_at")
    search_fields = ("report_id",)


# Register model admin classes here

# Register all models defined in models.py
models_dict = vars().copy()  # Create a copy of the dictionary
for model in models_dict.values():
    if hasattr(model, "_meta") and getattr(model._meta, "abstract", False) is False:
        admin.site.register(model)

# Assuming these are models within your 'home' app
admin.site.register(AnalyticsData)
admin.site.register(LogEntries)
admin.site.register(PublicReportingData)
admin.site.register(ReportingData)
# Continue registering other models explicitly
