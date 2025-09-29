from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from .. import models as db
from django.http import JsonResponse, HttpResponse
from ..decorators import allowed_users, app_available

@app_available
def views(request):
    app = db.App.objects.all().first()
    voter = "Votters"
    if request.user.is_authenticated:
        voter = db.Voter.objects.get(user__username=request.user)
        
    return render(request, "home.html", {"app": app, "voter": voter})

def views_fallback(request):
    """Fallback view when app is not configured"""
    try:
        # Try to get app, if not exists redirect to install
        app = db.App.objects.all().first()
        if not app:
            return redirect('install')
        else:
            return views(request)
    except Exception as e:
        # If database is not ready, show simple message
        return HttpResponse(f"""
        <html>
        <head><title>E-Voting - Starting Up</title></head>
        <body>
        <h1>E-Voting System</h1>
        <p>Application is starting up...</p>
        <p>Please wait a moment and refresh the page.</p>
        <p>If this issue persists, the application may need to be configured.</p>
        <p><a href="/install-app/">Go to Installation</a></p>
        </body>
        </html>
        """, content_type="text/html")