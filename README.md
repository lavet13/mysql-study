# mysql-study

Лабораторные работы по дисциплине «Инжиниринг и управление данными».

Каждая лабораторная работа — изолированная единица со своей базой данных,
SQL-схемой и автоматически генерируемым отчётом в формате `.docx`.

## Структура проекта

```
mysql-study/
├── docker-compose.yml          # Общие сервисы: phpMyAdmin, Prisma Studio
├── docker-compose.docs.yml     # Сервисы генерации документов: docs, node
│
├── templates/
│   ├── Dockerfile.node         # Node.js образ для генерации reference.docx
│   ├── make_reference.js       # Скрипт генерации шаблона стилей
│   ├── build-reference.sh      # Запуск генерации reference.docx
│   ├── build-reference.ps1     # То же для PowerShell
│   ├── merge.py                # Слияние титульного листа с содержимым
│   ├── lab-template.docx       # Шаблон титульного листа (не редактировать)
│   ├── reference.docx          # Шаблон стилей для Pandoc (генерируется)
│   └── package.json            # Зависимости для make_reference.js
│
├── lab-01/
│   ├── docker-compose.yml      # MySQL для этой лабораторной (порт 3307)
│   ├── init.sql                # Схема и данные базы
│   ├── report.md               # Содержимое отчёта на Markdown
│   ├── build.sh                # Генерация Отчет.docx
│   ├── build.ps1               # То же для PowerShell
│   ├── assets/                 # Скриншоты для отчёта
│   └── Отчет.docx              # Итоговый документ (генерируется)
│
├── lab-02/                     # Аналогичная структура
└── prisma/                     # Prisma Studio конфигурация (общая)
```

## Требования

Единственное требование — **Docker Desktop**.

- [Windows](https://www.docker.com/products/docker-desktop/) (рекомендуется WSL2)
- [macOS](https://www.docker.com/products/docker-desktop/)
- [Linux](https://docs.docker.com/desktop/install/linux-install/)

Node.js, Python, Pandoc устанавливать не нужно — всё работает внутри контейнеров.

---

## Первоначальная настройка (один раз после клонирования)

### 1. Собрать образы

```bash
# Образ для генерации документов (Pandoc + Python + docxcompose)
docker compose -f docker-compose.docs.yml build docs

# Образ для генерации reference.docx (Node.js)
docker compose -f docker-compose.docs.yml build node
```

### 2. Сгенерировать шаблон стилей

```bash
bash templates/build-reference.sh
```

Это создаёт `templates/reference.docx` — файл со всеми стилями Word
(шрифты, отступы, межстрочный интервал). Pandoc использует его при конвертации.

> Повторно запускать только если изменился `templates/make_reference.js`.

### 3. Запустить общие сервисы

```bash
docker compose up -d
```

Запускает:
| Сервис | URL | Назначение |
|---|---|---|
| phpMyAdmin | http://localhost:8081 | Веб-интерфейс для MySQL |
| Prisma Studio | http://localhost:5555 | Визуальный редактор БД |

Логин для обоих: `root` / `secret`

---

## Работа с лабораторной (пример: lab-01)

### 1. Запустить базу данных лабораторной

```bash
cd lab-01
docker compose up -d
cd ..
```

При первом запуске MySQL автоматически выполнит `lab-01/init.sql` —
создаст таблицы и заполнит их данными.

> Общие сервисы (phpMyAdmin, Prisma) должны быть запущены раньше,
> так как база подключается к их сети `mysql-shared`.

### 2. Проверить данные

- **phpMyAdmin** → http://localhost:8081 → база `lab`
- **Prisma Studio** → http://localhost:5555

### 3. Сделать скриншоты

Каждый отчёт требует минимум три скриншота. Сохранить в `lab-01/assets/`:

| Файл                    | Где делать                            | Что показать               |
| ----------------------- | ------------------------------------- | -------------------------- |
| `prisma-tables.png`     | Prisma Studio                         | Любая таблица с данными    |
| `prisma-diagram.png`    | Prisma Studio → вкладка визуализатора | Схема связей               |
| `phpmyadmin-tables.png` | phpMyAdmin                            | Список таблиц + содержимое |

### 4. Сгенерировать отчёт

```bash
bash lab-01/build.sh
```

Что происходит внутри:

1. Pandoc конвертирует `report.md` → `_content_tmp.docx` используя стили из `reference.docx`
2. `merge.py` создаёт титульный лист и объединяет его с содержимым
3. Результат сохраняется в `lab-01/Отчет.docx`
4. Временный файл `_content_tmp.docx` удаляется

### 5. Остановить базу данных

```bash
cd lab-01

# Остановить, сохранив данные (можно продолжить позже)
docker compose down

# Остановить и удалить данные (чистый старт в следующий раз)
docker compose down -v
```

---

## Добавление новой лабораторной (например, lab-02)

```bash
# Скопировать структуру из lab-01
cp -r lab-01 lab-02
```

Затем изменить в `lab-02/`:

**`docker-compose.yml`** — обновить порт и имя тома:

```yaml
ports:
  - "3308:3306"        # каждая лаба на своём порту: 3307, 3308, 3309...
container_name: mysql-lab02
volumes:
  - lab02-data:/var/lib/mysql
  ...
volumes:
  lab02-data:          # уникальное имя тома
```

**`build.sh`** — обновить переменные вверху файла:

```bash
LAB_NUMBER="2"
LAB_TITLE="..."
# и т.д.
```

**`init.sql`** — заменить схемой новой лабораторной.

**`report.md`** — заменить содержимым новой лабораторной.

---

## Генерация report.md с помощью ИИ

В корне проекта лежит файл `PROMPT_generate_report.md`.

Использование:

1. Открыть Claude или другой LLM
2. Прикрепить файл с заданиями лабораторных
3. Скопировать содержимое `PROMPT_generate_report.md` и вставить в чат
4. Указать номер лабораторной: _"сгенерируй отчёт для лабораторной №2"_
5. Скопировать содержимое из code block в `lab-02/report.md`

---

## Полезные команды

```bash
# Посмотреть все запущенные контейнеры
docker ps

# Пересобрать образ после изменения Dockerfile
docker compose -f docker-compose.docs.yml build --no-cache docs

# Удалить все остановленные контейнеры (не трогает данные)
docker container prune -f

# Полная очистка неиспользуемых образов и кэша сборки
docker system prune -f

# Принудительно пересоздать базу с нуля
cd lab-01
docker compose down -v
docker compose up -d
```

---

## Концепции Docker

Тонкие моменты, которые полезно понимать при работе с проектом.

### ENTRYPOINT vs CMD

Каждый Docker-образ имеет два необязательных поля:

```dockerfile
ENTRYPOINT ["pandoc"]     # фиксированный исполняемый файл — запускается всегда
CMD ["--version"]         # аргументы по умолчанию — используются только если не передано ничего
```

Когда контейнер запускается **без аргументов**:

```bash
docker compose -f docker-compose.docs.yml run --rm docs
# выполняется: pandoc --version   ← ENTRYPOINT + CMD объединяются
```

Когда аргументы **переданы**:

```bash
docker compose -f docker-compose.docs.yml run --rm docs lab-01/report.md -o lab-01/Отчет.docx
# выполняется: pandoc lab-01/report.md -o lab-01/Отчет.docx
# CMD полностью игнорируется — ваши аргументы заменяют его
```

Ключевое различие:

|              | Что делает             | Чем переопределяется           |
| ------------ | ---------------------- | ------------------------------ |
| `ENTRYPOINT` | Определяет программу   | Только флагом `--entrypoint`   |
| `CMD`        | Аргументы по умолчанию | Любыми переданными аргументами |

Именно поэтому в `build.sh` для запуска Python вместо Pandoc используется `--entrypoint`:

```bash
# Без --entrypoint: pandoc templates/merge.py ...  ← неверно
# С --entrypoint:   python3 templates/merge.py ...  ← верно
docker compose -f docker-compose.docs.yml run --rm \
  --entrypoint python3 docs \
  templates/merge.py ...
```

### Анонимные тома и node_modules

В сервисах `node` и `prisma` используется такой приём:

```yaml
volumes:
  - ./templates:/app # монтирует локальную папку в контейнер
  - /app/node_modules # анонимный том — защищает эту подпапку
```

Вторая строка без пути на хосте создаёт анонимный том, который перекрывает
bind mount для папки `node_modules`. Это гарантирует, что Docker использует
`node_modules`, установленные внутри образа при сборке, а не ищет их
в локальной папке (где их нет).

### Предупреждение об orphan containers

При запуске команд через `docker-compose.docs.yml` может появляться:

```
Found orphan containers ([mysql-docs-1]) for this project.
```

Это безопасно — можно игнорировать. Появляется потому что несколько
compose-файлов используют одно имя проекта. Убрать предупреждение:

```bash
docker compose -f docker-compose.docs.yml run --rm --remove-orphans docs ...
```

### Сеть mysql-shared

Сервисы из разных compose-файлов по умолчанию изолированы в отдельных сетях
и не видят друг друга. Чтобы Prisma и phpMyAdmin из корневого `docker-compose.yml`
могли обращаться к базе данных из `lab-01/docker-compose.yml` по имени `db`,
оба файла подключаются к одной именованной сети:

```yaml
# docker-compose.yml — создаёт сеть
networks:
  shared:
    name: mysql-shared

# lab-01/docker-compose.yml — подключается к существующей сети
networks:
  shared:
    external: true
    name: mysql-shared
```

Именно поэтому корневой `docker compose up -d` нужно запускать **раньше**
лабораторного — он создаёт сеть, к которой затем подключается база данных лабы.
