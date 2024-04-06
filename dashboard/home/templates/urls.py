from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('admin_black_pro.templates.urls')),
    path('accounts/', include('admin_black_pro.accounts.urls')),
]


from django.urls import path
from . import views

app_name = 'dashboard'

dashboard_patterns = [
    path("", views.dashboard, name="dashboard"),
    path("widgets/", views.widgets, name="widgets"),
    path("charts/", views.charts, name="charts"),
    path("calendar/", views.calendar, name="calendar"),
    path("template/", views.templates, name="template"),
]

components_patterns = [
    path("components/buttons/", views.buttons, name="buttons"),
    path("components/grid/", views.grid, name="grid"),
    path("components/panels/", views.panels, name="panels"),
    path("components/sweet-alert/", views.sweet_alert, name="sweet_alert"),
    path("components/notifications/", views.notifications, name="notifications"),
    path("components/icons/", views.icons, name="icons"),
    path("components/typography/", views.typography, name="typography"),
]

forms_patterns = [
    path("forms/regular-forms/", views.regular_forms, name="regular_forms"),
    path("forms/extended-forms/", views.extended_forms, name="extended_forms"),
    path("forms/validation-forms/", views.validation_forms, name="validation_forms"),
    path("forms/wizard/", views.wizard, name="wizard"),
]

tables_patterns = [
    path("tables/regular-tables/", views.regular_tables, name="regular_tables"),
    path("tables/extended-tables/", views.extended_tables, name="extended_tables"),
    path("tables/datatables/", views.datatables, name="datatables"),
]

maps_patterns = [
    path("maps/google-maps/", views.google_maps, name="google_maps"),
    path("maps/fullscreen-map/", views.fullscreen_map, name="fullscreen_map"),
    path("maps/vector-map/", views.vector_map, name="vector_map"),
]

pages_patterns = [
    path("pages/pricing/", views.pricing, name="pricing"),
    path("pages/timeline/", views.timeline, name="timeline"),
    path("pages/user-profile/", views.user_profile, name="user_profile"),
    path("pages/rtl/", views.rtl, name="rtl"),
]

urlpatterns = dashboard_patterns + components_patterns + forms_patterns + tables_patterns + maps_patterns + pages_patterns


from django.urls import path
from . import views

app_name = 'accounts'

urlpatterns = [
    path("login/", views.UserLoginView.as_view(), name="login"),
    path("register/", views.register, name="register"),
    path("logout/", views.user_logout, name="logout"),
    path("password-change/", views.UserPasswordChangeView.as_view(), name="password_change"),
    path("password-change-done/", views.UserPasswordChangeDoneView.as_view(), name="password_change_done"),
    path("password-reset/", views.UserPasswordResetView.as_view(), name="password_reset"),
    path("password-reset-confirm/<uidb64>/<token>/", views.UserPasswrodResetConfirmView.as_view(), name="password_reset_confirm"),
    path("password-reset-done/", views.UserPasswordResetDoneView.as_view(), name="password_reset_done"),
    path("password-reset-complete/", views.UserPasswordResetCompleteView.as_view(), name="password_reset_complete"),
    path("lock/", views.lock, name="lock"),
]
