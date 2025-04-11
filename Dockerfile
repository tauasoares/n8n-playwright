FROM node:20-slim

ENV DEBIAN_FRONTEND=noninteractive

# Instala dependências do sistema para Chromium/Playwright
RUN apt-get update && apt-get install -y \
    wget curl gnupg ca-certificates \
    fonts-liberation libatk-bridge2.0-0 libatk1.0-0 \
    libgtk-3-0 libx11-xcb1 libxcomposite1 libxdamage1 \
    libxrandr2 libasound2 libnss3 libxss1 libxtst6 libgbm1 \
    libpango-1.0-0 libpangocairo-1.0-0 libxshmfence1 libglu1-mesa \
    libu2f-udev --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala Playwright globalmente e baixa navegadores
RUN npm install -g playwright && \
    npx playwright install --with-deps

# Instala o n8n globalmente
RUN npm install -g n8n

# Cria usuário não-root e define permissões
RUN useradd -m nodeuser

# Define diretório de trabalho
WORKDIR /home/nodeuser

# Cria pasta de dados com permissões
RUN mkdir -p /home/nodeuser/.n8n && chown -R nodeuser:nodeuser /home/nodeuser

# Troca para o usuário não-root
USER nodeuser

# Expõe a porta padrão do n8n
EXPOSE 5678

# Comando padrão ao iniciar o container
CMD ["n8n"]
