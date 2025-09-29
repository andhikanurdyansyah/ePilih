from django.shortcuts import render
from django.http import JsonResponse
from django.contrib.auth.decorators import login_required
from .. import models as db
from ..decorators import allowed_users, app_available

@app_available
@login_required
@allowed_users(['admin'])
def views(request):
    app = db.App.objects.all().first()
    admin = db.Admin.objects.get(user__username=request.user)
    
    context = {
        "app": app,
        "admin": admin,
    }
    return render(request, "settings.html", context)

@login_required
@allowed_users(['admin'])
def update(request):
    result = { "status": False }
    
    if request.is_ajax():
        if request.method == "POST":
            name = request.POST.get('name')
            org = request.POST.get('org')
            start = request.POST.get('start')
            end = request.POST.get('end')
            logo = request.FILES.get('foto')
            
            print(f"DEBUG - Files received: {list(request.FILES.keys())}")
            print(f"DEBUG - Logo file: {logo}")
            
            if name and org:
                try:
                    settings = db.App.objects.all().first()
                    settings.app_name = name
                    settings.organization = org
                    
                    if logo:
                        print(f"DEBUG - Saving logo: {logo.name}, size: {logo.size}")
                        settings.app_logo = logo
                        
                        # Also save as base64 for Railway compatibility
                        import base64
                        logo_content = logo.read()
                        logo_base64 = base64.b64encode(logo_content).decode('utf-8')
                        logo_mime = logo.content_type or 'image/jpeg'
                        settings.app_logo_base64 = f"data:{logo_mime};base64,{logo_base64}"
                        print(f"DEBUG - Logo base64 saved, length: {len(settings.app_logo_base64)}")
                    if start:
                        settings.start_at = start
                    if end:
                        settings.end_at = end
                    settings.save()
                    
                    print(f"DEBUG - App logo after save: {settings.app_logo}")
                    result['status'] = True
                except Exception as e:
                    print(f"DEBUG - Error saving: {e}")
                    result['message'] = f"Ubah pengaturan gagal: {str(e)}"
            else:
                result['message'] = "Ada form yang masih kosong!"
                    
    return JsonResponse(result)           

@login_required
@allowed_users(['admin'])
def reset(request):
    result = { "status": False }
    
    if request.is_ajax():
        if request.method == "POST":
            try:
                db.Voter.objects.all().update(is_vote=False)
                db.Voice.objects.all().delete()
                result['status'] = True
            except:
                result['message'] = "Reset status voting gagal, coba lagi!"
                    
    return JsonResponse(result)     