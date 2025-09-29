"""
Simple database URL parser as fallback for dj-database-url compatibility issues
"""
import urllib.parse
import os

def parse_database_url(url, conn_max_age=0, conn_health_checks=False):
    """
    Simple DATABASE_URL parser for Railway compatibility
    """
    if not url:
        return None
    
    try:
        parsed = urllib.parse.urlparse(url)
        
        # Extract database info
        db_config = {
            'ENGINE': 'django.db.backends.postgresql',
            'NAME': parsed.path[1:] if parsed.path else 'railway',  # Remove leading slash
            'USER': parsed.username or 'postgres',
            'PASSWORD': parsed.password or '',
            'HOST': parsed.hostname or 'localhost',
            'PORT': parsed.port or 5432,
        }
        
        # Add connection options
        if conn_max_age:
            db_config['CONN_MAX_AGE'] = conn_max_age
            
        if conn_health_checks:
            db_config['CONN_HEALTH_CHECKS'] = conn_health_checks
            
        # Add common PostgreSQL options for Railway
        db_config['OPTIONS'] = {
            'connect_timeout': 60,
            'sslmode': 'prefer',
        }
        
        return db_config
        
    except Exception as e:
        print(f"Error parsing DATABASE_URL: {e}")
        return None

def get_database_config():
    """
    Get database configuration with Railway support
    """
    database_url = os.environ.get('DATABASE_URL')
    
    if database_url:
        print("Using Railway DATABASE_URL")
        config = parse_database_url(database_url, conn_max_age=600, conn_health_checks=True)
        if config:
            return config
    
    # Fallback to environment variables
    print("Using environment variables for database config")
    return {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('DB_NAME', 'epilih'),
        'USER': os.environ.get('DB_USER', 'epilihuser'),
        'PASSWORD': os.environ.get('DB_PASS', 'epilihpass'),
        'HOST': os.environ.get('DB_HOST', 'localhost'),
        'PORT': os.environ.get('DB_PORT', '5432'),
    }
