# Prompt: Generate lab report

Copy this entire prompt into Claude, Grok, Gemini, or any other LLM.
Attach TWO files before sending:
  1. The lab assignment (PDF or DOCX)
  2. The repomix codebase output (markdown file)

Then say: "сгенерируй отчёт для лабораторной №N"

---

You are helping me write a university lab report.
I will attach two files:
1. A PDF or DOCX file containing all my lab assignments
2. A markdown file containing my entire project codebase exported via repomix

Read both files carefully before generating anything.

From the assignment file, identify lab number [N] and extract:
- The lab topic/title
- The discipline name
- The goal of the lab
- The original data table(s) to work with
- What needs to be done (normalization steps, SQL tasks, etc.)

From the codebase file, learn:
- The existing project structure
- Naming conventions used in existing init.sql files
- The docker-compose.yml pattern used per lab
- The report.md structure and section style from existing labs

Then generate THREE complete files without asking me to fill in anything.
init.sql is shared across labs 2-11 and does not need to be generated.

## Output format

Return exactly three fenced code blocks and nothing else outside them,
except a one-line header before each block identifying the file.

Use four backticks as the outer fence so inner triple-backtick code blocks
do not accidentally close it:

File: lab-0N/report.md
````markdown
(full report content here)
````

File: lab-0N/docker-compose.yml
````yaml
(full docker-compose content here)
````

File: lab-0N/build.sh
````bash
(full build script content here)
````

Rules for docker-compose.yml:
- Copy the structure from lab-01/docker-compose.yml visible in the codebase
- Increment the host port by 1 per lab (lab-01=3307, lab-02=3308, lab-03=3309...)
- Update container_name, volume name, and volume declaration to match the lab number
- The init.sql volume mount must point to: ../student-init.sql:/docker-entrypoint-initdb.d/init.sql

Rules for build.sh:
- Copy the structure from lab-01/build.sh visible in the codebase
- Update LAB_NUMBER, LAB_TITLE, SUBJECT, and any other variables at the top
- All paths and docker commands stay identical — only the variables change
- Always include --resource-path="lab-0N" in the Pandoc command

Do not render or format the output — I need the raw syntax I can copy directly
into files.

---

## Rules for report.md

- Write entirely in Russian
- Do NOT include a title page — it is handled separately by the build pipeline
- Do NOT add a YAML front matter block at the top
- Do NOT use HTML tags or LaTeX
- Each section must have a short explanatory paragraph before any code or table
- Do NOT include a screenshot checklist section at the end

### Structure

Follow this section order:

1. Цель работы — one paragraph stating the goal
2. Настройка среды — explain the docker-compose.yml for this lab,
   describe each service directive the same way lab-01 does
3. Постановка задачи — show the original unnormalized table from the assignment
   as a Markdown table with all the original data rows
4. Нормализация — walk through each normal form step by step:
   - 1НФ: explain the violation, show the fixed table
   - 2НФ: explain the violation, show the split tables
   - 3НФ: explain the violation, show the final tables
5. Реализация — show the complete init.sql with inline comments explaining
   each CREATE TABLE and INSERT block
6. Проверка — one paragraph per required screenshot describing what it shows
7. Вывод — two to three sentences summarizing what was learned

### Headings

```markdown
# 1. Название раздела        → Heading 1
## 1.1 Подраздел             → Heading 2
### 1.1.1 Подподраздел       → Heading 3
```

Always number headings manually. Pandoc does not auto-number.

### Code blocks

Always specify the language tag:

```markdown
    ```sql
    SELECT * FROM ...
    ```

    ```yaml
    services:
      db:
        image: mysql:8.0
    ```

    ```bash
    docker compose up -d
    ```
```

### Tables

```markdown
| Колонка 1 | Колонка 2 | Колонка 3 |
|-----------|-----------|-----------|
| значение  | значение  | значение  |
```

The separator row `|---|---|---|` is required.

### Images

Use this exact pattern with sequential numbering starting from 1:

```markdown
![Рисунок 1 – Краткое описание](assets/step-01-description.png){ width=80% }
```

Rules:
- Number figures sequentially throughout the entire document (Рисунок 1, Рисунок 2, ...)
- Always include `{ width=80% }` after every image to prevent full-page images
- Use two-digit zero-padded numbers in filenames: step-01, step-02, step-10, step-11
- Description is 2-3 words joined by hyphens

### Page breaks

To insert a hard page break between major sections use:

```markdown
::: {custom-style="pagebreak"}
:::
```

Use this before each new # Heading 1 section to start it on a fresh page.

### Required images

Always include these three in section 6 (Проверка), numbered sequentially
after all other figures in the document:

- `assets/prisma-tables.png` — Prisma Studio showing a table with populated data
- `assets/prisma-diagram.png` — Prisma Studio data model visualizer showing relationships
- `assets/phpmyadmin-tables.png` — phpMyAdmin showing table list and contents

Add additional screenshots wherever they help illustrate the work:
terminal output of key commands, intermediate states, before/after comparisons.
