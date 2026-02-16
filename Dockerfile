FROM python:3.11-slim

# Install system dependencies (added ffi and ssl)
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libxslt-dev \
    libxml2-dev \
    zlib1g-dev \
    libffi-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# IMPORTANT: Only keep the next line if your repo IS EMPTY. 
# If your repo already has SearXNG files, remove this line:
RUN git clone https://github.com/searxng/searxng.git .

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir uwsgi

# Ensure the config directory exists before copying
RUN mkdir -p /etc/searxng
COPY settings.yml /etc/searxng/settings.yml

ENV SEARXNG_SETTINGS_PATH=/etc/searxng/settings.yml
# Allow Railway to set the port
ENV PORT=8080

EXPOSE 8080

# Using uWSGI is much more stable for Railway builds
# CMD uwsgi --http-socket :${PORT} --module searx.webapp --master --processes 4 --threads 2
CMD uwsgi --http-socket :${PORT:-8080} --module searx.webapp --master --processes 4 --threads 2
