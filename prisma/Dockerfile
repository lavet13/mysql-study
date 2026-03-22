FROM node:22-slim

# Устанавливаем системные зависимости для Prisma
RUN apt-get update && apt-get install -y openssl && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Сначала инициализируем пустой проект, чтобы создать package.json
RUN npm init -y

# Теперь устанавливаем зависимости
RUN npm install prisma@latest @prisma/client@latest dotenv

# Открываем порт для Studio
EXPOSE 5555

# Запускаем Prisma Studio
CMD npx prisma studio --port 5555 --browser none
