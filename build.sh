#!/bin/bash

virtualenv venv
source venv/bin/activate
pip --no-cache-dir install -r requirements.txt
