# Dockerfile
FROM node:18-slim

ENV DEBIAN_FRONTEND=noninteractive

# Instala libs para Chromium e Playwright
RUN apt-get update && apt-get install -y \
    wget curl gnupg ca-certificates \
    fonts-liberation libatk-bridge2.0-0 libatk1.0-0 \
    libgtk-3-0 libx11-xcb1 libxcomposite1 libxdamage1 \
    libxrandr2 libasound2 libnss3 libxss1 libxtst6 libgbm1 \
    libpango-1.0-0 libpangocairo-1.0-0 libxshmfence1 libglu1-mesa \
    libu2f-udev --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala Playwright com navegadores
RUN npm install -g playwright && \
    playwright install --with-deps

# Instala o n8n
RUN npm install -g n8n

# Cria usuário não-root
RUN useradd -m nodeuser
USER nodeuser
WORKDIR /home/nodeuser

# Cria pasta de dados
RUN mkdir -p /home/nodeuser/.n8n

# Expondo a porta padrão
EXPOSE 5678

CMD ["n8n"]
