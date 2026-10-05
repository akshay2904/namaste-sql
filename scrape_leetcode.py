"""
Scrape all LeetCode problems and save as markdown files.

Structure per file:
  - Metadata header (id, title, difficulty, tags, URL)
  - Problem description
  - Examples
  - Constraints

Usage:
    python scrape_leetcode.py
    python scrape_leetcode.py --resume   (skip already-scraped files)
"""
import json
import os
import re
import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from html.parser import HTMLParser

sys.stdout.reconfigure(encoding="utf-8", errors="replace")
from playwright.sync_api import sync_playwright

OUT_DIR  = os.path.join(os.path.dirname(__file__), "leetcode")
GRAPHQL  = "https://leetcode.com/graphql/"
BASE_URL = "https://leetcode.com"

LISTING_QUERY = """
query problemsetQuestionList($categorySlug: String, $limit: Int, $skip: Int, $filters: QuestionListFilterInput) {
  problemsetQuestionList: questionList(
    categorySlug: $categorySlug
    limit: $limit
    skip: $skip
    filters: $filters
  ) {
    total: totalNum
    questions: data {
      questionFrontendId
      title
      titleSlug
      difficulty
      isPaidOnly
      acRate
      topicTags { name slug }
    }
  }
}"""

CONTENT_QUERY = """
query questionContent($titleSlug: String!) {
  question(titleSlug: $titleSlug) {
    content
    hints
  }
}"""


# ── HTML → plain text ─────────────────────────────────────────────────────────

class _H2T(HTMLParser):
    BLOCK = {"p","div","br","li","h1","h2","h3","h4","tr","pre","blockquote"}
    def __init__(self):
        super().__init__()
        self.parts = []; self._skip = False
    def handle_starttag(self, tag, attrs):
        if tag in ("script","style"): self._skip = True
        if tag in self.BLOCK: self.parts.append("\n")
        if tag in ("td","th"): self.parts.append(" | ")
        if tag == "strong" or tag == "b": self.parts.append("**")
        if tag == "code": self.parts.append("`")
    def handle_endtag(self, tag):
        if tag in ("script","style"): self._skip = False
        if tag in self.BLOCK: self.parts.append("\n")
        if tag == "strong" or tag == "b": self.parts.append("**")
        if tag == "code": self.parts.append("`")
    def handle_data(self, data):
        if not self._skip: self.parts.append(data)
    def handle_entityref(self, name):
        m = {"nbsp":" ","amp":"&","lt":"<","gt":">","quot":'"'}
        if not self._skip: self.parts.append(m.get(name,""))
    def handle_charref(self, name):
        if not self._skip:
            try: self.parts.append(chr(int(name[1:],16) if name.startswith("x") else int(name)))
            except: pass

def html_to_text(html: str) -> str:
    p = _H2T(); p.feed(html or "")
    text = "".join(p.parts)
    return re.sub(r"\n{3,}", "\n\n", text).strip()


# ── File helpers ──────────────────────────────────────────────────────────────

def safe_filename(qid: str, title: str) -> str:
    name = re.sub(r'[\\/:*?"<>|\r\n\t]', "", title).strip(". ")
    return f"{qid.zfill(4)} - {name[:100]}.md"


def build_md(prob: dict, content_html: str, hints: list) -> str:
    tags = ", ".join(t["name"] for t in prob.get("topicTags") or []) or "N/A"
    ac   = f"{prob.get('acRate', 0):.1f}%" if prob.get("acRate") else "N/A"
    paid = "Premium" if prob["isPaidOnly"] else "Free"
    url  = f"{BASE_URL}/problems/{prob['titleSlug']}/"

    lines = [
        f"# {prob['questionFrontendId']}. {prob['title']}",
        "",
        f"**Difficulty:** {prob['difficulty'].capitalize()}",
        f"**Tags:** {tags}",
        f"**Acceptance Rate:** {ac}",
        f"**Access:** {paid}",
        f"**URL:** {url}",
        "",
        "---",
        "",
    ]

    if content_html:
        lines.append(html_to_text(content_html))
    else:
        lines.append("_Problem description unavailable (Premium required)._")

    if hints:
        lines += ["", "**Hints:**"]
        for i, h in enumerate(hints, 1):
            lines.append(f"{i}. {html_to_text(h)}")

    lines += ["", "---", "", "## Solution", "", "```python", "", "```", ""]
    return "\n".join(lines)


# ── Scraping with a shared Playwright browser ─────────────────────────────────

def make_gql_fn(page):
    """Return a callable that POSTs GraphQL via the browser's session."""
    def call(query: str, variables: dict) -> dict:
        result = page.evaluate(f"""async () => {{
            const r = await fetch('{GRAPHQL}', {{
                method: 'POST',
                headers: {{
                    'Content-Type': 'application/json',
                    'x-csrftoken': (document.cookie.match(/csrftoken=([^;]+)/) || [])[1] || '',
                    'Referer': 'https://leetcode.com/problemset/',
                }},
                body: JSON.stringify({{
                    query: {json.dumps(query)},
                    variables: {json.dumps(variables)}
                }})
            }});
            return r.json();
        }}""")
        return result
    return call


def fetch_all_listings(gql) -> list[dict]:
    problems, skip, limit = [], 0, 100
    while True:
        resp = gql(LISTING_QUERY, {
            "categorySlug": "",
            "skip": skip, "limit": limit,
            "filters": {}
        })
        data  = resp["data"]["problemsetQuestionList"]
        qs    = data["questions"]
        total = data["total"]
        if not qs:
            break
        problems.extend(qs)
        print(f"  fetched {len(problems)}/{total}")
        if len(problems) >= total:
            break
        skip += limit
        time.sleep(0.2)
    return problems


def fetch_content(gql, slug: str) -> tuple[str, list]:
    try:
        resp = gql(CONTENT_QUERY, {"titleSlug": slug})
        q = resp["data"]["question"] or {}
        return q.get("content") or "", q.get("hints") or []
    except Exception:
        return "", []


# ── Worker: one browser per thread ───────────────────────────────────────────

def worker_batch(batch: list[dict], resume: bool) -> list[str]:
    results = []
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        page.goto("https://leetcode.com/problemset/",
                  wait_until="domcontentloaded", timeout=30000)
        page.wait_for_timeout(3000)
        gql = make_gql_fn(page)

        for prob in batch:
            fname = safe_filename(prob["questionFrontendId"], prob["title"])
            fpath = os.path.join(OUT_DIR, fname)

            if resume and os.path.exists(fpath):
                results.append(f"SKIP {fname}")
                continue

            content_html, hints = fetch_content(gql, prob["titleSlug"])
            md = build_md(prob, content_html, hints)
            with open(fpath, "w", encoding="utf-8") as f:
                f.write(md)
            results.append(f"OK   {fname}")
            time.sleep(0.15)

        browser.close()
    return results


# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    resume  = "--resume" in sys.argv
    workers = int(next((sys.argv[i+1] for i, a in enumerate(sys.argv) if a == "--workers"), 4))
    os.makedirs(OUT_DIR, exist_ok=True)

    print("Step 1: Fetching problem listing...")
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        page.goto("https://leetcode.com/problemset/",
                  wait_until="domcontentloaded", timeout=30000)
        page.wait_for_timeout(4000)
        gql = make_gql_fn(page)
        problems = fetch_all_listings(gql)
        browser.close()

    with open(os.path.join(OUT_DIR, "_index.json"), "w", encoding="utf-8") as f:
        json.dump(problems, f, indent=2)
    print(f"  Total problems: {len(problems)}\n")

    print(f"Step 2: Scraping content ({workers} parallel browsers)...")
    batches = [problems[i::workers] for i in range(workers)]
    done = [0]
    total = len(problems)

    with ThreadPoolExecutor(max_workers=workers) as ex:
        futures = {ex.submit(worker_batch, b, resume): b for b in batches}
        for fut in as_completed(futures):
            for msg in fut.result():
                done[0] += 1
                print(f"  [{done[0]:04}/{total}] {msg}")

    print(f"\nDone! {total} files in: {OUT_DIR}")

    # Stats
    with open(os.path.join(OUT_DIR, "_index.json"), encoding="utf-8") as f:
        idx = json.load(f)
    by_diff = {}
    for q in idx:
        d = q["difficulty"].capitalize()
        by_diff[d] = by_diff.get(d, 0) + 1
    print("\nBy difficulty:")
    for k, v in sorted(by_diff.items()):
        print(f"  {k}: {v}")
    paid = sum(1 for q in idx if q["isPaidOnly"])
    print(f"\nFree: {len(idx)-paid}  |  Premium: {paid}")


if __name__ == "__main__":
    main()
