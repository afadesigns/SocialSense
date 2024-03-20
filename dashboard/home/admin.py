from django.contrib import admin

from .models import AnalyticsData, LogEntries, PublicReportingData, ReportingData


class LogEntriesAdmin(admin.ModelAdmin):
    list_display = ("id", "timestamp", "log_level")
    list_filter = ("log_level",)
    search_fields = ("message",)
    date_hierarchy = "timestamp"


class ReportingDataAdmin(admin.ModelAdmin):
    list_display = ("report_id", "created_at")
    search_fields = ("report_id", "created_at")


# Register model admin classes here
admin.site.register(AnalyticsData)
admin.site.register(LogEntries, LogEntriesAdmin)
admin.site.register(PublicReportingData)
admin.site.register(ReportingData, ReportingDataAdmin)
