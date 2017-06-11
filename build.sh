#!/bin/bash

virtualenv venv
source venv/bin/activate
pip --no-cache-dir install -r requirements.txt
npm install -g bower
bower --allow-root install
python hackathon_starter/manage.py makemigrations
python hackathon_starter/manage.py migrate
