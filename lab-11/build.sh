#!/usr/bin/env bash
#
# Builds lab-11/Отчет.docx from lab-11/report.md
# Run from the PROJECT ROOT:
#   bash lab-11/build.sh

set -e

LAB_NUMBER="11"
LAB_TITLE="Представления"
SUBJECT="Инжиниринг и управление данными"
GROUP="ИТИм-25"
STUDENT="Скиндер И.П."
TEACHER="доц. Романюк В.В."
CITY="Донецк"
YEAR="2026"

REPORT="lab-11/report.md"
CONTENT_TMP="lab-11/_content_tmp.docx"
OUTPUT="lab-11/Отчет.docx"
REFERENCE="templates/reference.docx"

echo "[1/2] Converting report.md to content.docx via Pandoc..."

docker compose -f docker-compose.docs.yml run --rm docs \
  "$REPORT" \
  -o "$CONTENT_TMP" \
  --reference-doc="$REFERENCE" \
  --resource-path="lab-11"

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
