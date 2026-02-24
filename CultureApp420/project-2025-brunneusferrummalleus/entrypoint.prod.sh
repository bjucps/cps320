#!/usr/bin/env bash

cd app

if [ $TEST ]; then
  coverage run manage.py test
else
  python manage.py migrate --noinput
  python manage.py collectstatic --noinput
  cp -R static /var/www/api/
  # python manage.py runserver 0.0.0.0:8000
  python -m gunicorn --bind 0.0.0.0:8000 --workers 3 brunneus_ferrum_malleus.wsgi:application
fi
