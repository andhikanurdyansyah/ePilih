from django.shortcuts import render
from django.http import JsonResponse
from django.contrib.auth.decorators import login_required
from .. import models as db
from django.contrib.auth.models import User
from random import randint
from tablib import Dataset
import uuid
from ..decorators import allowed_users, app_available

@app_available
@login_required
@allowed_users(['admin'])
def views(request):
    app = db.App.objects.all().first()
    admin = db.Admin.objects.get(user__username=request.user)
    division = db.Division.objects.all()
    candidates = db.Candidate.objects.all()
    
    context = {
        "app": app,
        "admin": admin,
        "division": division,
        "candidates": candidates
    }
    return render(request, "candidate.html", context)

@login_required
@allowed_users(['admin'])
def add(request):
    result = { "status": False }
    
    if request.is_ajax():
        if request.method == "POST":
            name = request.POST.get('name')
            division = request.POST.get('division')
            order = request.POST.get('order')
            foto = request.FILES.get('foto')
            vision = request.POST.get('vision')
            mission = request.POST.get('mission')
            
            print(f"DEBUG - Candidate add - Files received: {list(request.FILES.keys())}")
            print(f"DEBUG - Candidate photo: {foto}")
            
            if name and foto and mission and division and vision and order:
                try:
                    candidate = db.Candidate(
                        code=uuid.uuid4().hex[:8],
                        name=name, 
                        order=order, 
                        division=db.Division.objects.get(id=division),
                        vision=vision, 
                        mission=mission, 
                    )
                    
                    if foto:
                        print(f"DEBUG - Processing candidate photo: {foto.name}, size: {foto.size}")
                        
                        # Save as base64 for Railway compatibility
                        import base64
                        
                        foto.seek(0)
                        photo_content = foto.read()
                        print(f"DEBUG - Photo content read: {len(photo_content)} bytes")
                        
                        if photo_content:
                            photo_base64 = base64.b64encode(photo_content).decode('utf-8')
                            photo_mime = foto.content_type or 'image/jpeg'
                            candidate.photo_base64 = f"data:{photo_mime};base64,{photo_base64}"
                            print(f"DEBUG - Photo base64 saved, length: {len(candidate.photo_base64)}")
                            
                            # Try to save file too, but don't fail if it doesn't work
                            try:
                                foto.seek(0)
                                candidate.photo = foto
                                print(f"DEBUG - Photo file saved successfully")
                            except Exception as e:
                                print(f"DEBUG - Photo file save failed (using base64 instead): {e}")
                                candidate.photo = None
                    
                    candidate.save()
                    print(f"DEBUG - Candidate saved with photo_base64 length: {len(candidate.photo_base64) if candidate.photo_base64 else 0}")
                    result['status'] = True
                except Exception as e:
                    print(f"DEBUG - Error saving candidate: {e}")
                    import traceback
                    traceback.print_exc()
                    result['message'] = f"Tambah data kandidat gagal: {str(e)}"
            else:
                result['message'] = "Ada form yang masih kosong!"
                    
    return JsonResponse(result)

@login_required
@allowed_users(['admin'])
def update(request):
    result = { "status": False }
    
    if request.is_ajax():
        if request.method == "POST":
            name = request.POST.get('name')
            division = request.POST.get('division')
            order = request.POST.get('order')
            foto = request.FILES.get('foto')
            vision = request.POST.get('vision')
            mission = request.POST.get('mission')
            code = request.POST['code']
            
            print(f"DEBUG - Candidate update - Files received: {list(request.FILES.keys())}")
            print(f"DEBUG - Candidate photo: {foto}")
            
            if name and mission and division and vision and order:
                try:
                    candidate = db.Candidate.objects.get(code=code)
                    candidate.name = name
                    candidate.order = order
                    candidate.division = db.Division.objects.get(id=division)
                    
                    if foto:
                        print(f"DEBUG - Processing candidate photo update: {foto.name}, size: {foto.size}")
                        
                        # Save as base64 for Railway compatibility
                        import base64
                        
                        foto.seek(0)
                        photo_content = foto.read()
                        print(f"DEBUG - Photo content read: {len(photo_content)} bytes")
                        
                        if photo_content:
                            photo_base64 = base64.b64encode(photo_content).decode('utf-8')
                            photo_mime = foto.content_type or 'image/jpeg'
                            candidate.photo_base64 = f"data:{photo_mime};base64,{photo_base64}"
                            print(f"DEBUG - Photo base64 updated, length: {len(candidate.photo_base64)}")
                            
                            # Try to save file too, but don't fail if it doesn't work
                            try:
                                foto.seek(0)
                                candidate.photo = foto
                                print(f"DEBUG - Photo file updated successfully")
                            except Exception as e:
                                print(f"DEBUG - Photo file update failed (using base64 instead): {e}")
                        
                    candidate.vision = vision
                    candidate.mission = mission
                    candidate.save()
                    
                    print(f"DEBUG - Candidate updated with photo_base64 length: {len(candidate.photo_base64) if candidate.photo_base64 else 0}")
                    result['status'] = True
                except Exception as e:
                    print(f"DEBUG - Error updating candidate: {e}")
                    import traceback
                    traceback.print_exc()
                    result['message'] = f"Ubah data kandidat gagal: {str(e)}"
            else:
                result['message'] = "Ada form yang masih kosong!"
                    
    return JsonResponse(result)

@login_required
@allowed_users(['admin'])
def views_update(request, code):
    app = db.App.objects.all().first()
    admin = db.Admin.objects.get(user__username=request.user)
    division = db.Division.objects.all()
    candidates = db.Candidate.objects.get(code=code)
    
    context = {
        "app": app,
        "admin": admin,
        "division": division,
        "c": candidates
    }
    return render(request, 'candidate-update.html', context)

@login_required
@allowed_users(['admin'])
def delete(request):
    result = { "status": False }
    
    if request.is_ajax():
        if request.method == "POST":
            code = request.POST.get('code')
            
            try:
                candidate = db.Candidate.objects.get(code=code)
                candidate.delete()
                
                result['status'] = True
            except:
                result['message'] = "Hapus data kandidat gagal, coba lagi!"
                    
    return JsonResponse(result)                     