#!/bin/bash

pip --no-cache-dir install virtualenv
virtualenv venv
source venv/bin/activate
pip --no-cache-dir install -r requirements.txt
