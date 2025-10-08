#!/bin/bash

set -e

echo "Deployment started ... "

echo "Copying new changes ..."
git pull origin main
echo "New changes copied to server !!"

source ../venv/bin/activate
echo "Virtual env activated !"

echo "clearing cache"
python manage.py clean_pyc
python manage.py clear_cache

echo "installing Dependencies"
pip install -r requirements.txt --no-input

echo "serving static files"
python manage.py collectstatic --noinput

echo "running database migrations"
python manage.py makemigrations
python manage.py migrate

deactivate
echo "virtual env deactivated"

ps aux | grep gunicorn | grep pro_action | awk '{ print $2 }' | xargs kill -HUP

echo "deploymeny finished!!!!!!"
