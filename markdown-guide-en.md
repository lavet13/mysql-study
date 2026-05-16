# Markdown → DOCX Syntax Guide

This file explains how Markdown syntax in `report.md` translates to Word
formatting after Pandoc converts it using `templates/reference.docx`.

---

## Headings → Word Heading Styles

```markdown
# 1. Настройка среды          → Heading 1 (bold, no indent, space above)
## 1.1 Подраздел              → Heading 2 (bold, no indent)
### 1.1.1 Подподраздел        → Heading 3 (bold italic, no indent)
```

**Rule:** Always number your headings manually in the text (`1.`, `1.1`).
Pandoc doesn't auto-number — you write the numbers yourself.

---

## Body text → Normal style

Any plain paragraph becomes the `Normal` style:
Times New Roman 14pt, 1.5 line spacing, 1.25cm first-line indent, justified.

```markdown
Это обычный абзац. Он будет отформатирован с отступом первой строки
и выравниванием по ширине.
```

**Gotcha:** Leave a **blank line** between paragraphs. Without a blank line,
Pandoc treats consecutive lines as one paragraph.

```markdown
Первый абзац.

Второй абзац.   ← blank line required
```

---

## Bold and italic

```markdown
**жирный текст**        → bold
*курсив*                → italic
***жирный курсив***     → bold italic
```

---

## Code blocks → Source Code style

Wrap code in triple backticks with an optional language tag for syntax info:

````markdown
```sql
SELECT * FROM Employees WHERE dept_id = 128;
```

```yaml
services:
  db:
    image: mysql:8.0
```

```bash
docker compose up -d
```
````

Renders as: Courier New 10pt, single spacing, left-indented block.

**Gotcha:** The language tag (`sql`, `yaml`, `bash`) is optional but good practice.
Pandoc uses it for syntax highlighting if enabled, but with our reference it
just affects the style name — all code blocks use `Source Code` style regardless.

---

## Tables → Table style (bordered, Times New Roman 14pt)

```markdown
| Код сотр. | ФИО         | Должность   |
|-----------|-------------|-------------|
| 7513      | Иванов И.И. | Программист |
| 9842      | Сергеева С. | Админ БД    |
```

**Rules:**
- The `|---|---|---|` separator row is **required** — it tells Pandoc this is a table
- Column widths are set automatically based on content
- Header row is the first row (above the separator)
- Cell text uses `Compact` style: TNR 14pt, 1.15 line spacing, no before/after spacing

**Alignment in columns** (optional):

```markdown
| Left      | Center      | Right       |
|:----------|:-----------:|------------:|
| text      | text        | text        |
```

---

## Images → embedded in document

```markdown
![Рисунок – Таблица сотрудников](assets/employees.png)
```

- Path is **relative to `report.md`** — so `assets/` means `lab-01/assets/`
- The text in `[]` becomes the alt text (shown if image is missing)
- Put your screenshots in `lab-XX/assets/` before building

**If an image is missing**, Pandoc prints a warning and replaces it with
the alt text in brackets — the build still succeeds.

---

## Horizontal rule → page separator (visual only)

```markdown
---
```

Renders as a horizontal line. Useful for visually separating sections
in the source file. Does **not** insert a page break.

---

## Forced page break

Pandoc doesn't have a Markdown syntax for page breaks.
If you need one, use a raw OpenDocument pagebreak div:

```markdown
::: {custom-style="pagebreak"}
:::
```

In practice, section headings with `Heading 1` naturally push content
and you rarely need manual page breaks in the body.

---

## Links

```markdown
[текст ссылки](https://example.com)

<https://github.com/lavet13/mysql-study>   ← auto-linked URL
```

---

## Lists

```markdown
- Первый элемент       ← unordered (bullet)
- Второй элемент
  - Вложенный          ← indent with 2 spaces for nesting

1. Первый шаг          ← ordered (numbered)
2. Второй шаг
```

**Gotcha:** Leave a blank line before the first list item if it follows
a paragraph, otherwise Pandoc may not recognize it as a list.

---

## Inline code (single backtick)

```markdown
Используйте команду `docker compose up -d` для запуска.
```

Renders as monospace inline text within a normal paragraph.

---

## What NOT to include in report.md

- **No title page** — handled by `templates/merge.py` + `lab-template.docx`
- **No YAML front matter** (`---` at the very top of the file) — not needed
- **No HTML tags** — they won't render correctly in docx output
- **No LaTeX** — same reason

---

## Full minimal example

```markdown
# 1. Настройка среды

Для работы используется Docker Compose. Ниже представлен файл конфигурации.

## 1.1 Файл docker-compose.yml

Описание каждой директивы приведено в комментариях.

```yaml
services:
  db:
    image: mysql:8.0
```

### Таблица сервисов

| Сервис     | Порт | Назначение         |
|------------|------|--------------------|
| db         | 3306 | База данных MySQL  |
| phpmyadmin | 8081 | Веб-интерфейс      |

![Рисунок – Запущенные контейнеры](assets/containers.png)

## Вывод

В ходе работы была настроена среда разработки на основе Docker.
```
