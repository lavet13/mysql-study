#!/usr/bin/env bash
#
# Builds lab-07/Отчет.docx from lab-07/report.md
# Run from the PROJECT ROOT:
#   bash lab-07/build.sh

set -e

LAB_NUMBER="7"
LAB_TITLE="Простые подзапросы"
SUBJECT="Инжиниринг и управление данными"
GROUP="ИТИм-25"
STUDENT="Скиндер И.П."
TEACHER="доц. Романюк В.В."
CITY="Донецк"
YEAR="2026"

REPORT="lab-07/report.md"
CONTENT_TMP="lab-07/_content_tmp.docx"
OUTPUT="lab-07/Отчет.docx"
REFERENCE="templates/reference.docx"

echo "[1/2] Converting report.md to content.docx via Pandoc..."

docker compose -f docker-compose.docs.yml run --rm docs \
  "$REPORT" \
  -o "$CONTENT_TMP" \
  --reference-doc="$REFERENCE" \
  --resource-path="lab-07"

echo "[2/2] Merging title page with content..."

docker compose -f docker-compose.docs.yml run --rm \
  --entrypoint python3 docs \
  templates/merge.py \
  --lab     "$LAB_NUMBER" \
  --title   "$LAB_TITLE" \
  --subject "$SUBJECT" \
  --group   "$GROUP" \
  --student "$STUDENT" \
  --teacher "$TEACHER" \
  --city
