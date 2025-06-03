FROM python:3.10

WORKDIR /app

COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

COPY . .

ENV PYTHONUNBUFFERED=1

# Perlu untuk meng-collect static files saat build
RUN python manage.py collectstatic --noinput || true

CMD ["gunicorn", "evoting.wsgi:application", "--bind", "0.0.0.0:8000"]
