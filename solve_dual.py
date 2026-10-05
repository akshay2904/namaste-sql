"""
Generate TWO SQL solutions (Optimized + Brute Force) for every problem.

Targets:
  --namaste   : questions/ folder  (re-solve all Medium/Hard/Extreme Hard)
  --strata    : stratascratch/ folder
  --both      : both (default)

Options:
  --resume    : skip files that already have APPROACH 1 written
  --workers N : parallel API threads (default 4)

Usage:
  $env:ANTHROPIC_API_KEY = "sk-ant-..."
  python solve_dual.py --both
  python solve_dual.py --strata --resume
"""
import anthropic
import json
import os
import re
import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed

# ── Config ────────────────────────────────────────────────────────────────────

MODEL   = "claude-sonnet-4-6"           # accuracy over speed
MAX_TOK = 2048

SYSTEM_PROMPT = """\
You are an expert SQL developer specializing in data analytics problems.
Given a SQL coding problem, write exactly TWO correct solutions.

Rules:
- Output ONLY SQL — no markdown fences, no prose explanations outside comments
- Brief inline comments only where logic is non-obvious
- Use standard SQL compatible with PostgreSQL
- Both solutions must produce identical correct results

Format your output EXACTLY as follows (keep the separator lines verbatim):

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

<optimized SQL here>

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

<brute force SQL here>
"""

SEPARATOR_1 = "-- APPROACH 1: OPTIMIZED"
SEPARATOR_2 = "-- APPROACH 2: BRUTE FORCE"
SOLUTION_MARKER = "-- Write your SQL solution below:"

# ── Helpers ───────────────────────────────────────────────────────────────────

def get_api_key() -> str:
    key = os.environ.get("ANTHROPIC_API_KEY", "").strip()
    if key:
        return key
    key = input("Paste your Anthropic API key: ").strip()
    if not key:
        sys.exit("No API key provided.")
    return key


def extract_question(content: str) -> str:
    m = re.search(r"/\*(.*?)\*/", content, re.DOTALL)
    return m.group(1).strip() if m else ""


def already_solved(content: str) -> bool:
    return SEPARATOR_1 in content


def strip_old_solution(content: str) -> str:
    """Remove any existing solution below the marker (including markdown fences)."""
    idx = content.find(SOLUTION_MARKER)
    if idx == -1:
        return content
    return content[: idx + len(SOLUTION_MARKER)] + "\n"


def write_dual_solution(filepath: str, solution_text: str):
    with open(filepath, encoding="utf-8") as f:
        content = f.read()
    base = strip_old_solution(content)
    # Clean up any markdown fences the model might sneak in
    solution_text = re.sub(r"```sql\s*", "", solution_text)
    solution_text = re.sub(r"```\s*", "", solution_text)
    new_content = base + "\n" + solution_text.strip() + "\n"
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(new_content)


def solve_one(client: anthropic.Anthropic, question: str) -> str:
    msg = client.messages.create(
        model=MODEL,
        max_tokens=MAX_TOK,
        system=SYSTEM_PROMPT,
        messages=[{"role": "user", "content": question}],
    )
    return msg.content[0].text.strip()


# ── Problem discovery ─────────────────────────────────────────────────────────

def get_namaste_files() -> list[str]:
    """Return paths of Medium/Hard/Extreme Hard NamasteSQL .sql files."""
    q_dir = os.path.join(os.path.dirname(__file__), "questions")
    meta  = os.path.join(os.path.dirname(__file__), "problems.json")
    with open(meta, encoding="utf-8") as f:
        data = json.load(f)

    target_diffs = {"Medium", "Hard", "Extreme Hard"}
    titles = {p["title"] for p in data if p["difficulty"] in target_diffs}

    def _norm(s):
        s = s.encode("ascii", errors="ignore").decode()
        return re.sub(r"[\s\-–—_]+", " ", s).lower().strip()

    norm_titles = {_norm(t) for t in titles}
    paths = []
    for fname in os.listdir(q_dir):
        if not fname.endswith(".sql"):
            continue
        if _norm(fname[:-4]) in norm_titles:
            paths.append(os.path.join(q_dir, fname))
    return sorted(paths)


def get_strata_files() -> list[str]:
    s_dir = os.path.join(os.path.dirname(__file__), "stratascratch")
    return sorted(
        os.path.join(s_dir, f)
        for f in os.listdir(s_dir)
        if f.endswith(".sql") and not f.startswith("_")
    )


# ── Main loop ─────────────────────────────────────────────────────────────────

def solve_batch(files: list[str], client: anthropic.Anthropic,
                resume: bool, workers: int, label: str):
    pending = []
    for fp in files:
        with open(fp, encoding="utf-8") as f:
            content = f.read()
        if resume and already_solved(content):
            continue
        q = extract_question(content)
        if q:
            pending.append((fp, q))

    total = len(pending)
    print(f"\n[{label}] {total} files to solve ({len(files)-total} skipped).")
    if not total:
        return

    done = [0]

    def _solve(item):
        fp, question = item
        for attempt in range(3):
            try:
                sol = solve_one(client, question)
                return fp, sol, None
            except anthropic.RateLimitError:
                time.sleep(30 * (attempt + 1))
            except Exception as e:
                return fp, None, str(e)
        return fp, None, "rate limit retries exhausted"

    with ThreadPoolExecutor(max_workers=workers) as ex:
        futures = {ex.submit(_solve, item): item for item in pending}
        for fut in as_completed(futures):
            fp, sol, err = fut.result()
            done[0] += 1
            name = os.path.basename(fp)
            if err:
                print(f"  [{done[0]:04}/{total}] ERROR {name}: {err}")
            else:
                write_dual_solution(fp, sol)
                print(f"  [{done[0]:04}/{total}] OK  {name}")


def main():
    args = sys.argv[1:]
    do_namaste = "--namaste" in args or "--both" in args or not any(
        a in args for a in ["--namaste", "--strata", "--both"]
    )
    do_strata  = "--strata"  in args or "--both" in args or not any(
        a in args for a in ["--namaste", "--strata", "--both"]
    )
    resume  = "--resume"  in args
    workers = int(next((args[i+1] for i, a in enumerate(args) if a == "--workers"), 4))

    api_key = get_api_key()
    client  = anthropic.Anthropic(api_key=api_key)

    if do_namaste:
        files = get_namaste_files()
        print(f"NamasteSQL: {len(files)} Medium/Hard/Extreme Hard files found.")
        solve_batch(files, client, resume, workers, "NamasteSQL")

    if do_strata:
        files = get_strata_files()
        print(f"StrataScratch: {len(files)} files found.")
        solve_batch(files, client, resume, workers, "StrataScratch")

    print("\nAll done.")


if __name__ == "__main__":
    main()
