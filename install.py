#!/usr/bin/env python3
"""AK Health Check installer — creates all query reports + dashboard via REST API.

Usage (interactive prompts — recommended to avoid shell escaping issues with passwords):
    python3 install.py

Or with env vars (beware: zsh escapes ! in passwords even in single quotes):
    AK_USER=user AK_PASS=pass AK_HOST=instance.actionkit.com python3 install.py
"""
import json
import os
import re
import sys
import urllib.request
import urllib.error
import base64
from pathlib import Path


def make_auth_header(user, password):
    creds = base64.b64encode(f"{user}:{password}".encode()).decode()
    return {"Authorization": f"Basic {creds}"}


def api_request(base_url, path, auth_headers, method="GET", data=None):
    url = f"{base_url}{path}"
    headers = {**auth_headers, "Accept": "application/json"}
    body = None
    if data is not None:
        headers["Content-Type"] = "application/json"
        body = json.dumps(data).encode()
    req = urllib.request.Request(url, data=body, headers=headers, method=method)
    try:
        resp = urllib.request.urlopen(req)
        return resp.status, resp.read().decode()
    except urllib.error.HTTPError as e:
        return e.code, e.read().decode()


def parse_sql_file(filepath):
    """Extract short_name, title, description, and SQL from a query file."""
    content = filepath.read_text()
    lines = content.split("\n")

    short_name = ""
    title = ""
    desc = ""
    in_header = False
    header_end = 0

    for i, line in enumerate(lines):
        if line.startswith("-- ====") and not in_header:
            in_header = True
            continue
        if line.startswith("-- ====") and in_header:
            header_end = i + 1
            break
        if line.startswith("-- Short name:"):
            short_name = line.split(":", 1)[1].strip()
        if line.startswith("-- AK Health Check:"):
            title = line.split(":", 1)[1].strip()
        if line.startswith("-- Description:"):
            desc = line.split(":", 1)[1].strip()

    # SQL is everything after the header block, stripped of empty lines
    sql_lines = [l for l in lines[header_end:] if l.strip()]
    sql = "\n".join(sql_lines)

    return short_name, title, desc, sql


def main():
    ak_user = os.environ.get("AK_USER") or input("AK username: ").strip()
    ak_pass = os.environ.get("AK_PASS") or input("AK password: ").strip()
    ak_host = os.environ.get("AK_HOST") or input("AK host (e.g. roboticdogs.actionkit.com): ").strip()

    # Strip backslash escaping that zsh adds to ! in env vars
    ak_pass = ak_pass.replace("\\!", "!")

    base_url = f"https://{ak_host}/rest/v1"
    auth = make_auth_header(ak_user, ak_pass)
    script_dir = Path(__file__).parent
    queries_dir = script_dir / "queries"

    print(f"Installing AK Health Check on {ak_host}")
    print("=" * 50)

    # Auth check — single request before looping
    print("Testing authentication...")
    status, body = api_request(base_url, "/queryreport/?_limit=1", auth)
    if status == 200:
        print(f"OK    Authenticated as {ak_user}")
    elif status == 401:
        print("FAIL  Authentication failed (HTTP 401). Check username and password.")
        sys.exit(1)
    elif status == 403:
        print("FAIL  Account locked (HTTP 403). Wait and try again later.")
        sys.exit(1)
    else:
        print(f"FAIL  Unexpected response (HTTP {status})")
        print(body[:200])
        sys.exit(1)
    print()

    errors = 0

    # Create each query report
    for sql_file in sorted(queries_dir.glob("*.sql")):
        short_name, title, desc, sql = parse_sql_file(sql_file)

        if not short_name or not title:
            print(f"SKIP  {sql_file.name} — could not parse header")
            continue

        payload = {
            "name": f"Health Check: {title}",
            "short_name": short_name,
            "description": desc,
            "sql": sql,
        }

        status, body = api_request(base_url, "/queryreport/", auth, method="POST", data=payload)

        if status == 201:
            print(f"OK    {short_name}")
        else:
            print(f"FAIL  {short_name} (HTTP {status})")
            # Show useful error info
            try:
                err = json.loads(body)
                for field, msgs in err.items():
                    print(f"      {field}: {msgs}")
            except (json.JSONDecodeError, AttributeError):
                print(f"      {body[:200]}")
            errors += 1

    # Create the dashboard
    print()
    print("Creating dashboard...")
    dashboard_html = (script_dir / "dashboard.html").read_text()

    dash_payload = {
        "name": "Health Check",
        "short_name": "health_check",
        "description": "Instance health check dashboard",
        "template": dashboard_html,
    }

    status, body = api_request(base_url, "/dashboardreport/", auth, method="POST", data=dash_payload)

    if status == 201:
        print("OK    health_check dashboard")
    else:
        print(f"FAIL  health_check dashboard (HTTP {status})")
        try:
            err = json.loads(body)
            for field, msgs in err.items():
                print(f"      {field}: {msgs}")
        except (json.JSONDecodeError, AttributeError):
            print(f"      {body[:200]}")
        errors += 1

    print()
    print("=" * 50)
    if errors == 0:
        print("All reports installed. View at:")
        print(f"  https://{ak_host}/report/view/health_check/")
    else:
        print(f"Finished with {errors} error(s). Check output above.")

    sys.exit(1 if errors else 0)


if __name__ == "__main__":
    main()
