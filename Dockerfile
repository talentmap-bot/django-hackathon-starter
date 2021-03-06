FROM python:2.7-alpine

# Copy your application code to the container (make sure you create a .dockerignore file if any large files or directories should be excluded)
RUN mkdir /code/
WORKDIR /code/
ADD . /code/

# uWSGI will listen on this port
EXPOSE 8000

RUN chmod +x /code/entrypoint.sh
RUN chmod +x /code/build.sh

RUN apk add --update bash
ENTRYPOINT ["/code/entrypoint.sh"]
