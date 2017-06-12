FROM python:2.7-alpine

# Copy your application code to the container (make sure you create a .dockerignore file if any large files or directories should be excluded)
RUN mkdir /code/
WORKDIR /code/
ADD . /code/

RUN ls -l
# uWSGI will listen on this port
EXPOSE 8000

ENTRYPOINT ["/code/build.sh"]
