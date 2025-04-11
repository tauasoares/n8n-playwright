FROM n8nio/n8n:latest

USER root
RUN apt-get update && apt-get install -y \
    wget gnupg curl libnss3 libatk-bridge2.0-0 libxss1 libasound2 libxshmfence1 libgbm1 libgtk-3-0 libx11-xcb1 \
    && npm install -g playwright \
    && npx playwright install

USER node

CMD ["n8n"]
