#!/bin/bash

virtualenv venv
source venv/bin/activate
pip --no-cache-dir install -r requirements.txt
npm install -g bower
bower install
python manage.py makemigrations
python manage.py migrate
