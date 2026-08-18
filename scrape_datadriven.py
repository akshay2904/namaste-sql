"""
Scrape SQL practice problems (with worked solutions) from datadriven.io.

Each problem page server-renders its full data (problem statement, table
schema, sample rows, and a canonical SQL solution) inside a Next.js RSC
payload — no login, no JS execution, no paid API needed. This walks the
sitemap, fetches each /problems/<slug> page, pulls out the SQL-domain ones,
and writes one .sql file per problem (same layout as questions/*.sql).

Usage:
    python scrape_datadriven.py
"""
import json
import os
import re
import time
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed

OUT_DIR = os.path.join(os.path.dirname(__file__), "datadriven")
META_FILE = os.path.join(OUT_DIR, "_problems.json")
SITEMAP = "https://datadriven.io/sitemap/3.xml"
HEADERS = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"}
WORKERS = 8

STR_RE = re.compile(r'"(?:[^"\\]|\\.)*"', re.DOTALL)


def fetch(url: str) -> str:
    req = urllib.request.Request(url, headers=HEADERS)
    with urllib.request.urlopen(req, timeout=20) as r:
        return r.read().decode("utf-8", errors="replace")


def get_slugs() -> list[str]:
    xml = fetch(SITEMAP)
    urls = re.findall(r"<loc>(https://datadriven\.io/problems/[^<]+)</loc>", xml)
    return sorted({u.rsplit("/", 1)[-1] for u in urls})


def find_container(obj, key):
    """Recursively find the dict that directly contains `key`; return that dict."""
    if isinstance(obj, dict):
        if key in obj:
            return obj
        for v in obj.values():
            r = find_container(v, key)
            if r is not None:
                return r
    elif isinstance(obj, list):
        for v in obj:
            r = find_container(v, key)
            if r is not None:
                return r
    return None


def extract_challenge(html: str) -> dict | None:
    """Pull the `initialChallenge` object out of the page's RSC payload."""
    for m in re.finditer(r"self\.__next_f\.push\(\[1,", html):
        sm = STR_RE.match(html, m.end())
        if not sm:
            continue
        try:
            blob = json.loads(sm.group(0))
        except json.JSONDecodeError:
            continue
        if "initialChallenge" not in blob:
            continue
        for line in blob.split("\n"):
            idx = line.find(":")
            if idx == -1 or not line[idx + 1 : idx + 2] in "[{":
                continue
            try:
                obj = json.loads(line[idx + 1 :])
            except json.JSONDecodeError:
                continue
            container = find_container(obj, "initialChallenge")
            if container:
                return container["initialChallenge"]
    return None


def safe_filename(title: str) -> str:
    name = re.sub(r'[\\/:*?"<>|\r\n\t]', "", title).strip(". ")
    return name[:120] + ".sql"


def build_sql(ch: dict, slug: str) -> tuple[str, str, bool]:
    """Return (filename, file content, has_solution)."""
    catalog = ch.get("catalog") or {}
    title = catalog.get("title") or slug
    difficulty = (catalog.get("difficultyLevel") or "unknown").capitalize()
    company = ch.get("company_name") or "N/A"
    access = "Free" if catalog.get("isFreeToAttempt") else "Premium (viewable)"
    url = f"https://datadriven.io/problems/{slug}"

    scenario = ch.get("scenario") or {}
    sql_scenario = ((scenario.get("domainSpecific") or {}).get("sql")) or {}
    tables = sql_scenario.get("dataTables") or []
    sample = sql_scenario.get("sampleData") or {}

    lines = [
        "-- " + "=" * 70,
        f"-- {title}",
        "-- " + "=" * 70,
        f"-- Difficulty : {difficulty}",
        f"-- Company    : {company}",
        f"-- Access     : {access}",
        "-- Source     : DataDriven.io",
        f"-- URL        : {url}",
        "-- " + "=" * 70,
        "",
        "/*",
        (scenario.get("problemStatement") or "").strip(),
    ]

    for t in tables:
        cols = ", ".join(t.get("columns", []))
        lines.append("")
        lines.append(f"Table: {t.get('name')}({cols})")

    input_tables = sample.get("input_tables") or []
    for it in input_tables:
        lines.append("")
        lines.append(f"Sample data - {it.get('name')} {it.get('columns')}:")
        for row in (it.get("rows") or [])[:5]:
            lines.append(f"  {row}")

    expected = sample.get("expected_output")
    if expected:
        lines.append("")
        lines.append(f"Expected output {expected.get('columns')}:")
        for row in (expected.get("rows") or [])[:5]:
            lines.append(f"  {row}")

    lines += ["*/", "", "", "-- Write your SQL solution below:", ""]

    solution_sql = None
    for b in (ch.get("deepDiveContent") or {}).get("blocks", []):
        if b.get("blockRole") == "canonical_solution":
            solution_sql = b.get("code")
            break

    if solution_sql:
        lines.append(solution_sql.strip())
        lines.append("")

    return safe_filename(title), "\n".join(lines), bool(solution_sql)


def process_slug(slug: str):
    try:
        html = fetch(f"https://datadriven.io/problems/{slug}")
    except Exception as e:
        return slug, None, f"fetch error: {e}"
    ch = extract_challenge(html)
    if not ch:
        return slug, None, "no challenge data found"
    domain = (ch.get("catalog") or {}).get("domain")
    if domain != "sql":
        return slug, None, None  # not a SQL problem, silently skip
    return slug, ch, None


def main():
    os.makedirs(OUT_DIR, exist_ok=True)

    print("Fetching problem list from sitemap...")
    slugs = get_slugs()
    print(f"  {len(slugs)} total problems (all domains)\n")

    print(f"Fetching each problem page ({WORKERS} parallel workers)...")
    sql_problems = []
    done = 0
    with ThreadPoolExecutor(max_workers=WORKERS) as ex:
        futures = {ex.submit(process_slug, s): s for s in slugs}
        for fut in as_completed(futures):
            slug, ch, err = fut.result()
            done += 1
            if done % 100 == 0:
                print(f"  [{done}/{len(slugs)}] processed, {len(sql_problems)} SQL so far")
            if err:
                print(f"  WARN {slug}: {err}")
                continue
            if ch:
                sql_problems.append((slug, ch))

    print(f"\nSQL problems found: {len(sql_problems)}")

    meta = []
    no_solution = 0
    used_names = set()
    for slug, ch in sql_problems:
        fname, content, has_solution = build_sql(ch, slug)
        key = fname.lower()
        if key in used_names:
            fname = fname[:-4] + f" - {slug}.sql"
            key = fname.lower()
        used_names.add(key)
        with open(os.path.join(OUT_DIR, fname), "w", encoding="utf-8") as f:
            f.write(content)
        if not has_solution:
            no_solution += 1
        catalog = ch.get("catalog") or {}
        meta.append({
            "slug": slug,
            "title": catalog.get("title"),
            "filename": fname,
            "difficulty": (catalog.get("difficultyLevel") or "unknown").capitalize(),
            "company": ch.get("company_name"),
            "is_free_to_attempt": catalog.get("isFreeToAttempt"),
            "has_solution": has_solution,
            "url": f"https://datadriven.io/problems/{slug}",
        })

    with open(META_FILE, "w", encoding="utf-8") as f:
        json.dump(meta, f, indent=2, ensure_ascii=False)

    print(f"\nSaved {len(meta)} .sql files to {OUT_DIR}/")
    print(f"Metadata saved to {META_FILE}")
    print(f"Problems missing a canonical solution: {no_solution}")

    by_diff = {}
    for m in meta:
        by_diff[m["difficulty"]] = by_diff.get(m["difficulty"], 0) + 1
    print("\nBy difficulty:")
    for k, v in sorted(by_diff.items()):
        print(f"  {k}: {v}")


if __name__ == "__main__":
    main()
