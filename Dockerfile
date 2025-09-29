# Gunakan image Python resmi
FROM python:3.12-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set work directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy project files
COPY . .

# Expose port 
EXPOSE $PORT

# Jalankan migrate dan collectstatic saat container dijalankan
CMD ["sh", "-c", "python manage.py migrate && python manage.py collectstatic --noinput && gunicorn evoting.wsgi:application --bind 0.0.0.0:${PORT:-8000}"]
