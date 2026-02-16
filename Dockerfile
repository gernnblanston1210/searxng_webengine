FROM docker:24-dind

WORKDIR /app
COPY . .

RUN chmod +x start.sh

CMD ["sh", "start.sh"]
