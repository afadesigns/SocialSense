from django.shortcuts import render
from django.http import HttpResponse

# Create your views here.

def index(request):
    """
    This view function renders the dashboard page.
    Add any view-specific logic here before rendering the template.
    """
    # Page from the theme 
    context = {
        'sample_data': 'This is a sample data point.'
    }
    return render(request, 'pages/dashboard.html', context)

