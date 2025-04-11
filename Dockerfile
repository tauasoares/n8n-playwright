# Dockerfile
FROM node:18-slim

ENV DEBIAN_FRONTEND=noninteractive

# Instala libs necessárias para Chromium e Playwright
RUN apt-get update && apt-get install -y \
    wget curl gnupg ca-certificates \
    fonts-liberation libatk-bridge2.0-0 libatk1.0-0 \
    libgtk-3-0 libx11-xcb1 libxcomposite1 libxdamage1 \
    libxrandr2 libasound2 libnss3 libxss1 libxtst6 libgbm1 \
    libpango-1.0-0 libpangocairo-1.0-0 libxshmfence1 libglu1-mesa \
    libu2f-udev --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Cria usuário não-root
RUN useradd -m nodeuser

# Instala Playwright com navegadores como nodeuser (importante!)
USER nodeuser
WORKDIR /home/nodeuser
RUN npm install -g playwright && \
    playwright install --with-deps

# Volta pro root para instalar o n8n
USER root
RUN npm install -g n8n

# Define permissões corretas da pasta do n8n
RUN mkdir -p /home/nodeuser/.n8n && \
    chown -R nodeuser:nodeuser /home/nodeuser/.n8n

# Volta pro nodeuser para rodar o n8n
USER nodeuser
WORKDIR /home/nodeuser

# Expõe a porta padrão
EXPOSE 5678

CMD ["n8n"]
