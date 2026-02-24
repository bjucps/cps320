#!/bin/bash
set -e

echo "Running migrations..."
python manage.py makemigrations --noinput
python manage.py migrate --noinput


STATIC_ROOT="/app/staticfiles"
echo "Ensuring static folder exists at $STATIC_ROOT..."
mkdir -p $STATIC_ROOT


echo "Collecting static files..."
python manage.py collectstatic --noinput

echo "Starting Django server..."
python manage.py loadjson pamphletmaker/events.json
echo "data loaded..."
exec python manage.py runserver 0.0.0.0:8001
