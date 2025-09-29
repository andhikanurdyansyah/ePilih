from django.core.management.base import BaseCommand
from django.contrib.auth.models import User
from django.core.files.base import ContentFile
from website.models import App, Admin
import datetime
import os
import shutil

class Command(BaseCommand):
    help = 'Initialize app for Railway deployment'
    
    def handle(self, *args, **options):
        self.stdout.write('Initializing application for deployment...')
        
        # Create App record if it doesn't exist
        app, created = App.objects.get_or_create(
            defaults={
                'app_name': 'ePilih',
                'organization': 'Pemilihan calon walikota',
                'start_at': datetime.datetime(2024, 1, 1, 0, 0, 0),
                'end_at': datetime.datetime(2025, 12, 31, 23, 59, 59),
            }
        )
        
        # Add default logo if app was created or doesn't have logo
        if created or not app.app_logo:
            try:
                # Copy default logo from static files to media
                static_logo_path = 'website/static/assets/images/template-logo.jpg'
                if os.path.exists(static_logo_path):
                    with open(static_logo_path, 'rb') as logo_file:
                        app.app_logo.save(
                            'default-logo.jpg',
                            ContentFile(logo_file.read()),
                            save=True
                        )
                    self.stdout.write(self.style.SUCCESS('✓ Default logo added'))
                else:
                    self.stdout.write(self.style.WARNING('⚠️ Default logo file not found'))
            except Exception as e:
                self.stdout.write(self.style.WARNING(f'⚠️ Logo setup failed: {e}'))
        
        if created:
            self.stdout.write(self.style.SUCCESS('✓ App record created'))
        else:
            self.stdout.write('App record already exists')
        
        # Create superuser if it doesn't exist
        admin_user, user_created = User.objects.get_or_create(
            username='admin',
            defaults={
                'email': 'admin@railway.app',
                'is_staff': True,
                'is_superuser': True,
            }
        )
        
        if user_created:
            admin_user.set_password('admin123')
            admin_user.save()
            self.stdout.write(self.style.SUCCESS('✓ Admin user created: admin/admin123'))
        else:
            self.stdout.write('Admin user already exists')
            
        # Create Admin record if it doesn't exist  
        try:
            admin_record, admin_created = Admin.objects.get_or_create(
                user=admin_user,
                defaults={
                    'level': 'admin'
                }
            )
            
            if admin_created:
                self.stdout.write(self.style.SUCCESS('✓ Admin record created'))
            else:
                self.stdout.write('Admin record already exists')
                
        except Exception as e:
            self.stdout.write(self.style.WARNING(f'Admin record creation skipped: {e}'))
        
        self.stdout.write(self.style.SUCCESS('Application initialization complete!'))
