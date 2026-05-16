# lab-01/build.ps1
#
# Builds lab-01/Отчет.docx from lab-01/report.md and templates/lab-template.docx
#
# Run from the PROJECT ROOT (not from inside lab-01/):
#   .\lab-01\build.ps1
#
# PowerShell equivalent of build.sh — same steps, same variables.

$ErrorActionPreference = "Stop"  # exit on any error, equivalent to bash set -e

# == Lab-specific variables ====================================================

$LAB_NUMBER = "1"
$LAB_TITLE  = "Разработка базы данных. Основы работы в MySQL"
$SUBJECT    = "Инжиниринг и управление данными"
$GROUP      = "ИТИм-25"
$STUDENT    = "Скиндер И.П."
$TEACHER    = "доц. Романюк В.В."
$CITY       = "Донецк"
$YEAR       = "2026"

# == Paths =====================================================================

$REPORT      = "lab-01/report.md"
$CONTENT_TMP = "lab-01/_content_tmp.docx"
$OUTPUT      = "lab-01/Отчет.docx"
$REFERENCE   = "templates/reference.docx"

# == Step 1: Pandoc ============================================================

Write-Host "[1/2] Converting report.md to content.docx via Pandoc..."

docker compose -f docker-compose.docs.yml run --rm docs `
  $REPORT `
  -o $CONTENT_TMP `
  --reference-doc=$REFERENCE

# == Step 2: Merge =============================================================

Write-Host "[2/2] Merging title page with content..."

docker compose -f docker-compose.docs.yml run --rm `
  --entrypoint python3 docs `
  templates/merge.py `
  --lab     $LAB_NUMBER `
  --title   $LAB_TITLE `
  --subject $SUBJECT `
  --group   $GROUP `
  --student $STUDENT `
  --teacher $TEACHER `
  --city    $CITY `
  --year    $YEAR `
  --content $CONTENT_TMP `
  --output  $OUTPUT

# == Step 3: Cleanup ===========================================================

Remove-Item -Force $CONTENT_TMP -ErrorAction SilentlyContinue

Write-Host "Done: $OUTPUT"
