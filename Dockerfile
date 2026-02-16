FROM python:3.11-slim

WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libxslt-dev \
    libxml2-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone SearxNG
# RUN git clone https://github.com/searxng/searxng.git .

# Install Python deps
RUN pip install --no-cache-dir -r requirements.txt

# Copy your settings
COPY settings /etc/searxng

ENV SEARXNG_SETTINGS_PATH=/etc/searxng/settings.yml
ENV PORT=8080

EXPOSE 8080

CMD ["python", "-m", "searx.webapp"]
