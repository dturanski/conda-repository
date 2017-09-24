FROM python:3.6-slim
RUN mkdir -p /opt/functions

ENTRYPOINT ["/bin/sh","-c", "cd /opt && python -m http.server"]
