FROM python:3.11-slim

# 1. Install system dependencies
RUN apt-get update && apt-get install -y \
    git build-essential libxslt-dev libxml2-dev \
    zlib1g-dev libffi-dev libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. Set the working directory
WORKDIR /usr/local/searxng

# 3. Clone and install
RUN git clone https://github.com/searxng/searxng.git . \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir uwsgi

# 4. Handle settings
RUN mkdir -p /etc/searxng
COPY settings.yml /etc/searxng/settings.yml

# 5. Environment Variables
ENV SEARXNG_SETTINGS_PATH=/etc/searxng/settings.yml
ENV PYTHONPATH=/usr/local/searxng
ENV PORT=8080

# 6. The Command (Crucial for Railway)
# We use '0.0.0.0' to ensure it listens externally
CMD uwsgi --http-socket 0.0.0.0:${PORT} \
    --module searx.webapp \
    --master \
    --processes 4 \
    --threads 2
