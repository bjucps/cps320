#!/usr/bin/env bash

echo "Running migrations"
python manage.py migrate --noinput

echo "Collecting static files"
python manage.py collectstatic --noinput

# autoreload mode set to 'stat' for better performance in Docker
export DJANGO_AUTORELOAD_MODE=stat

echo "Starting Django server!!"
python manage.py runserver 0.0.0.0:8000