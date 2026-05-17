#!/usr/bin/env bash
#
# Builds lab-10/Отчет.docx from lab-10/report.md
# Run from the PROJECT ROOT:
#   bash lab-10/build.sh

set -e

LAB_NUMBER="10"
LAB_TITLE="Добавление, удаление и изменение данных"
SUBJECT="Инжиниринг и управление данными"
GROUP="ИТИм-25"
STUDENT="Скиндер И.П."
TEACHER="доц. Романюк В.В."
CITY="Донецк"
YEAR="2026"

REPORT="lab-10/report.md"
CONTENT_TMP="lab-10/_content_tmp.docx"
OUTPUT="lab-10/Отчет.docx"
REFERENCE="templates/reference.docx"

echo "[1/2] Converting report.md to content.docx via Pandoc..."

docker compose -f docker-compose.docs.yml run --rm docs \
  "$REPORT" \
  -o "$CONTENT_TMP" \
  --reference-doc="$REFERENCE" \
  --resource-path="lab-10"

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
  --city    "$CITY" \
  --year    "$YEAR" \
  --content "$CONTENT_TMP" \
  --output  "$OUTPUT"

rm -f "$CONTENT_TMP"

echo "Done: $OUTPUT"
