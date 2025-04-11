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

# Instala Playwright como root (obrigatório para -g)
RUN npm install -g playwright && \
    npx playwright install --with-deps

# Instala n8n
RUN npm install -g n8n

# Ajusta permissões da pasta de cache do Playwright (importante!)
RUN mkdir -p /home/nodeuser/.cache && \
    chown -R nodeuser:nodeuser /home/nodeuser/.cache

# Define usuário final como nodeuser
USER nodeuser
WORKDIR /home/nodeuser

# Cria pasta de dados e garante permissões
RUN mkdir -p /home/nodeuser/.n8n

# Expõe a porta padrão
EXPOSE 5678

CMD ["n8n"]
