FROM node:18

# Instala dependências do sistema
RUN apt-get update && apt-get install -y \
    wget gnupg curl libnss3 libatk-bridge2.0-0 libxss1 libasound2 libxshmfence1 libgbm1 libgtk-3-0 libx11-xcb1

# Instala n8n e playwright
RUN npm install -g n8n playwright && \
    npx playwright install

# Cria usuário n8n
RUN useradd -m -s /bin/bash node

USER node

CMD ["n8n"]
