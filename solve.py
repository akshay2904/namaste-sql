"""
Generate SQL solutions for all Medium and Hard NamasteSQL problems using Claude.

Usage:
    python solve.py                  # prompts for API key
    python solve.py --resume         # skip files that already have a solution
    ANTHROPIC_API_KEY=sk-... python solve.py
"""
import anthropic
import json
import os
import re
import sys
import time

QUESTIONS_DIR = os.path.join(os.path.dirname(__file__), "questions")
PROBLEMS_JSON = os.path.join(os.path.dirname(__file__), "problems.json")
MODEL = "claude-haiku-4-5-20251001"   # fast + cheap for batch work

SYSTEM_PROMPT = """\
You are an expert SQL developer. Given a coding problem statement, write a clean, \
correct SQL solution. Output ONLY the SQL code with no explanation or markdown fences. \
Use standard SQL compatible with most databases (PostgreSQL / MySQL). \
Add brief inline comments only when a step is non-obvious."""


def get_api_key() -> str:
    key = os.environ.get("ANTHROPIC_API_KEY", "").strip()
    if key:
        return key
    key = input("Paste your Anthropic API key: ").strip()
    if not key:
        sys.exit("No API key provided.")
    return key


def load_problems() -> list[dict]:
    with open(PROBLEMS_JSON, encoding="utf-8") as f:
        data = json.load(f)
    return [p for p in data if p["difficulty"] in ("Medium", "Hard", "Extreme Hard")]


def sql_filename(title: str) -> str:
    name = re.sub(r'[\\/:*?"<>|]', "", title).strip(". ")
    return name[:120] + ".sql"


def _normalize(s: str) -> str:
    """Strip non-ASCII, collapse all dash/space variants, lowercase."""
    s = s.encode("ascii", errors="ignore").decode()  # drop non-ASCII
    s = re.sub(r"[\s\-–—_]+", " ", s).lower().strip()
    return s


def find_file(title: str) -> str | None:
    """Find the .sql file for a problem, handling en-dashes and encoding variants."""
    exact = os.path.join(QUESTIONS_DIR, sql_filename(title))
    if os.path.exists(exact):
        return exact
    norm = _normalize(title)
    for fname in os.listdir(QUESTIONS_DIR):
        if not fname.endswith(".sql"):
            continue
        if _normalize(fname[:-4]) == norm:
            return os.path.join(QUESTIONS_DIR, fname)
    return None


def read_question_block(filepath: str) -> str:
    """Extract text between /* and */ (the problem statement)."""
    with open(filepath, encoding="utf-8") as f:
        content = f.read()
    m = re.search(r"/\*(.*?)\*/", content, re.DOTALL)
    return m.group(1).strip() if m else ""


def already_solved(filepath: str) -> bool:
    """Return True if there is any SQL after the solution marker."""
    with open(filepath, encoding="utf-8") as f:
        content = f.read()
    marker = "-- Write your SQL solution below:"
    idx = content.find(marker)
    if idx == -1:
        return False
    after = content[idx + len(marker):].strip()
    return bool(after)


def write_solution(filepath: str, solution: str):
    with open(filepath, encoding="utf-8") as f:
        content = f.read()
    marker = "-- Write your SQL solution below:"
    idx = content.find(marker)
    if idx == -1:
        return
    new_content = content[: idx + len(marker)] + "\n\n" + solution.strip() + "\n"
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(new_content)


def solve_one(client: anthropic.Anthropic, question: str) -> str:
    msg = client.messages.create(
        model=MODEL,
        max_tokens=1024,
        system=SYSTEM_PROMPT,
        messages=[{"role": "user", "content": question}],
    )
    return msg.content[0].text.strip()


def main():
    resume = "--resume" in sys.argv
    api_key = get_api_key()
    client = anthropic.Anthropic(api_key=api_key)

    problems = load_problems()
    print(f"\nFound {len(problems)} Medium/Hard problems to solve.")
    if resume:
        print("--resume mode: skipping already-solved files.")
    print()

    solved = skipped = errors = 0

    for i, prob in enumerate(problems, 1):
        filepath = find_file(prob["title"])

        if not filepath:
            print(f"[{i:03}/{len(problems)}] MISSING FILE: {prob['title']}")
            errors += 1
            continue

        if resume and already_solved(filepath):
            print(f"[{i:03}/{len(problems)}] SKIP (already solved): {prob['title']}")
            skipped += 1
            continue

        question = read_question_block(filepath)
        if not question:
            print(f"[{i:03}/{len(problems)}] SKIP (no question block): {filename}")
            skipped += 1
            continue

        print(f"[{i:03}/{len(problems)}] Solving: {prob['title']} [{prob['difficulty']}]", end=" ... ", flush=True)
        try:
            solution = solve_one(client, question)
            write_solution(filepath, solution)
            print("done")
            solved += 1
        except anthropic.RateLimitError:
            print("rate limit — sleeping 30s")
            time.sleep(30)
            try:
                solution = solve_one(client, question)
                write_solution(filepath, solution)
                print("done (retry)")
                solved += 1
            except Exception as e:
                print(f"ERROR: {e}")
                errors += 1
        except Exception as e:
            print(f"ERROR: {e}")
            errors += 1

        time.sleep(0.5)  # stay within rate limits

    print(f"\n{'='*50}")
    print(f"Solved:  {solved}")
    print(f"Skipped: {skipped}")
    print(f"Errors:  {errors}")


if __name__ == "__main__":
    main()
