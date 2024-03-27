from django.contrib.auth.decorators import login_required
from django.shortcuts import render


@login_required
def index(request):
    # No InstagramService usage; focus on dashboard-specific data and logic only.
    return render(request, "admin/index.html", context)
