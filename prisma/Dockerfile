FROM node:18-slim

# Устанавливаем системные зависимости для Prisma
RUN apt-get update && apt-get install -y openssl && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Кэширование зависимостей: сначала копируем только package.json
# (Если его нет, npm install создаст его сам)
RUN npm install prisma @prisma/client dotenv

# Открываем порт для Studio
EXPOSE 5555

# Запускаем Prisma Studio
CMD npx prisma studio --browser none
