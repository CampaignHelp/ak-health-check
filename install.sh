#!/bin/bash
# AK Health Check installer — creates all query reports + dashboard via REST API
# Usage: AK_USER=user AK_PASS=pass AK_HOST=instance.actionkit.com ./install.sh

set -euo pipefail

AK_USER="${AK_USER:?Set AK_USER}"
AK_PASS="${AK_PASS:?Set AK_PASS}"
AK_HOST="${AK_HOST:?Set AK_HOST}"
BASE="https://${AK_HOST}/rest/v1"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
QUERIES_DIR="${SCRIPT_DIR}/queries"

echo "Installing AK Health Check on ${AK_HOST}"
echo "==========================================="

# Auth check — single request before we loop, to avoid lockout
echo "Testing authentication..."
auth_code=$(curl -s -o /tmp/ak_response.txt -w '%{http_code}' \
    -u "${AK_USER}:${AK_PASS}" \
    "${BASE}/queryreport/?_limit=1")

if [ "$auth_code" = "200" ]; then
    echo "OK    Authenticated as ${AK_USER}"
elif [ "$auth_code" = "401" ]; then
    echo "FAIL  Authentication failed (HTTP 401). Check username and password."
    echo "      Note: AK REST API uses the username field, not email."
    rm -f /tmp/ak_response.txt
    exit 1
elif [ "$auth_code" = "403" ]; then
    echo "FAIL  Account locked (HTTP 403). Wait and try again later."
    rm -f /tmp/ak_response.txt
    exit 1
else
    echo "FAIL  Unexpected response (HTTP ${auth_code})"
    cat /tmp/ak_response.txt 2>/dev/null | head -3
    rm -f /tmp/ak_response.txt
    exit 1
fi
echo ""

errors=0

# Create each query report
for sql_file in "${QUERIES_DIR}"/*.sql; do
    filename=$(basename "$sql_file")

    # Extract short name from header
    short_name=$(grep '^-- Short name:' "$sql_file" | sed 's/^-- Short name: *//')

    # Extract title from header (after "AK Health Check: ")
    title=$(grep '^-- AK Health Check:' "$sql_file" | sed 's/^-- AK Health Check: *//')

    # Extract description
    desc=$(grep '^-- Description:' "$sql_file" | sed 's/^-- Description: *//')

    # Extract SQL (everything after the header block)
    sql=$(sed -n '/^-- ====.*====$/,/^-- ====.*====$/!p; /^-- ====.*====$/d' "$sql_file" | sed '/^$/d')

    if [ -z "$short_name" ] || [ -z "$title" ]; then
        echo "SKIP  ${filename} — could not parse header"
        continue
    fi

    # Build JSON payload
    payload=$(jq -n \
        --arg name "Health Check: ${title}" \
        --arg short_name "$short_name" \
        --arg description "$desc" \
        --arg sql "$sql" \
        '{name: $name, short_name: $short_name, description: $description, sql: $sql}')

    # POST to queryreport endpoint
    http_code=$(curl -s -o /tmp/ak_response.txt -w '%{http_code}' \
        -u "${AK_USER}:${AK_PASS}" \
        -H "Content-Type: application/json" \
        -d "$payload" \
        "${BASE}/queryreport/")

    if [ "$http_code" = "201" ]; then
        echo "OK    ${short_name}"
    else
        echo "FAIL  ${short_name} (HTTP ${http_code})"
        cat /tmp/ak_response.txt 2>/dev/null | head -5
        echo ""
        errors=$((errors + 1))
    fi
done

# Create the dashboard report
echo ""
echo "Creating dashboard..."

dashboard_html=$(cat "${SCRIPT_DIR}/dashboard.html")

dash_payload=$(jq -n \
    --arg name "Health Check" \
    --arg short_name "health_check" \
    --arg description "Instance health check dashboard — staff security, list health, fundraising, mailing hygiene, data quality" \
    --arg template "$dashboard_html" \
    '{name: $name, short_name: $short_name, description: $description, template: $template}')

http_code=$(curl -s -o /tmp/ak_response.txt -w '%{http_code}' \
    -u "${AK_USER}:${AK_PASS}" \
    -H "Content-Type: application/json" \
    -d "$dash_payload" \
    "${BASE}/dashboardreport/")

if [ "$http_code" = "201" ]; then
    echo "OK    health_check dashboard"
else
    echo "FAIL  health_check dashboard (HTTP ${http_code})"
    cat /tmp/ak_response.txt 2>/dev/null | head -5
    echo ""
    errors=$((errors + 1))
fi

echo ""
echo "==========================================="
if [ "$errors" -eq 0 ]; then
    echo "All reports installed. View at:"
    echo "  https://${AK_HOST}/report/view/health_check/"
else
    echo "Finished with ${errors} error(s). Check output above."
fi

rm -f /tmp/ak_response.txt
