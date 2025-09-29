from django.http import JsonResponse, HttpResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_GET
from website.models import App

@require_GET
@csrf_exempt
def health_check(request):
    """Simple health check endpoint for Railway"""
    try:
        # Check if database is accessible
        app_count = App.objects.count()
        
        return JsonResponse({
            'status': 'healthy',
            'database': 'connected',
            'apps_configured': app_count > 0,
            'message': 'E-Voting application is running'
        })
    except Exception as e:
        return JsonResponse({
            'status': 'unhealthy',
            'error': str(e),
            'message': 'Database connection failed'
        }, status=500)

@require_GET 
@csrf_exempt
def ping(request):
    """Simple ping endpoint"""
    return HttpResponse("pong", content_type="text/plain")
