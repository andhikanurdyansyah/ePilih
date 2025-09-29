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
            
            # Debug all received data
            print(f"DEBUG - POST data: {dict(request.POST)}")
            print(f"DEBUG - FILES data: {dict(request.FILES)}")
            
            # Try to get logo file with different possible names
            logo = request.FILES.get('foto') or request.FILES.get('logo')
            print(f"DEBUG - Logo file: {logo}")
            
            if name and org:
                try:
                    settings = db.App.objects.all().first()
                    settings.app_name = name
                    settings.organization = org
                    
                    if logo:
                        print(f"DEBUG - Processing logo: {logo.name}, size: {logo.size}, type: {logo.content_type}")
                        
                        # Save as base64 for Railway compatibility
                        import base64
                        
                        # Reset file position to beginning
                        logo.seek(0)
                        logo_content = logo.read()
                        print(f"DEBUG - Logo content read: {len(logo_content)} bytes")
                        
                        if logo_content:
                            logo_base64 = base64.b64encode(logo_content).decode('utf-8')
                            logo_mime = logo.content_type or 'image/jpeg'
                            settings.app_logo_base64 = f"data:{logo_mime};base64,{logo_base64}"
                            print(f"DEBUG - Logo base64 saved, length: {len(settings.app_logo_base64)}")
                            
                            # Try to save file too, but don't fail if it doesn't work
                            try:
                                # Reset file position again for file save
                                logo.seek(0)
                                settings.app_logo = logo
                                print(f"DEBUG - Logo file saved successfully")
                            except Exception as e:
                                print(f"DEBUG - Logo file save failed (using base64 instead): {e}")
                                # Reset file field since file save failed
                                settings.app_logo = None
                        else:
                            print(f"DEBUG - Logo content is empty!")
                    else:
                        print(f"DEBUG - No logo file provided")
                        
                    if start:
                        settings.start_at = start
                    if end:
                        settings.end_at = end
                    settings.save()
                    
                    print(f"DEBUG - App logo after save: {settings.app_logo}")
                    print(f"DEBUG - App logo_base64 length: {len(settings.app_logo_base64) if settings.app_logo_base64 else 0}")
                    result['status'] = True
                except Exception as e:
                    print(f"DEBUG - Error saving: {e}")
                    import traceback
                    traceback.print_exc()
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