"""Scrape datadriven.io data-modeling and pipeline-architecture problems to Markdown.

Writes datadriven/data-modeling/*.md and datadriven/pipeline-architecture/*.md.
Reuses fetch/extract_challenge from scrape_datadriven.py.
"""
import re
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

from scrape_datadriven import extract_challenge, fetch

OUT = Path(__file__).parent / "datadriven"
DOMAINS = {"data_modeling": "data-modeling", "pipeline_architecture": "pipeline-architecture"}


def mermaid(edges, nodes=None):
    lines = ["```mermaid", "flowchart LR"]
    for n in nodes or []:
        label = n["name"] + (f"<br/>{n['tech_label']}" if n.get("tech_label") else "")
        lines.append(f'    {n["name"]}["{label}"]')
    lines += [f"    {e['from']} --> {e['to']}" for e in edges]
    return "\n".join(lines + ["```"])


def render_block(b):
    try:
        return _render_block(b)
    except (KeyError, TypeError):
        # unknown shape: keep any text rather than drop it
        return "\n\n".join(str(v) for k, v in b.items() if isinstance(v, str) and k not in ("blockType", "type"))


def _render_block(b):
    t = b.get("blockType") or b.get("type")
    if t == "heading":
        return f"### {b['blockText']}"
    if t == "paragraph":
        return b["blockText"]
    if t == "divider":
        return "---"
    if t == "callout":
        body = "\n".join(f"> {l}" if l else ">" for l in b["body"].split("\n"))
        return f"> **{b.get('title', '')}**\n>\n{body}"
    if t == "step":
        return f"**Step {b.get('number', '')}: {b['title']}**\n\n{b['body']}"
    if t == "code":
        return f"**{b.get('title', '')}**\n\n```{b.get('language', '')}\n{b['code']}\n```"
    if t == "comparison":
        return (f"| {b['left_label']} | {b['right_label']} |\n|---|---|\n"
                f"| {b['left_body']} | {b['right_body']} |")
    if t == "follow_up":
        return "\n".join(f"- **{q['question']}**\n  - _{q.get('context', '')}_" for q in b["questions"])
    if t == "schema_diagram":
        out = [mermaid(b.get("edges", []))]
        for tbl in b.get("tables", []):
            out.append(f"**{tbl['name']}**\n\n| column | type | key |\n|---|---|---|")
            out += [f"| {c['name']} | {c.get('type', '')} | {c.get('key_type') or ''} |" for c in tbl["columns"]]
            out.append("")
        return "\n".join(out)
    if t == "pipeline_diagram":
        out = [mermaid(b.get("edges", []), b.get("nodes", [])), "", "| node | type | tech | details |", "|---|---|---|---|"]
        for n in b.get("nodes", []):
            extra = "; ".join(f"{k}: {v}" for k, v in n.items() if k not in ("name", "node_type", "tech_label"))
            out.append(f"| {n['name']} | {n.get('node_type', '')} | {n.get('tech_label', '')} | {extra} |")
        return "\n".join(out)
    raise KeyError(t)


def build_md(ch, slug):
    cat = ch["catalog"]
    grading = ch.get("problemModeGrading") or {}
    out = [
        f"# {cat['title']}",
        f"_{cat.get('tagline', '')}_\n" if cat.get("tagline") else "",
        f"- **Domain:** {cat['domain']}",
        f"- **Difficulty:** {(cat.get('difficultyLevel') or 'unknown').capitalize()}",
        f"- **Est. time:** {cat.get('estimatedMinutesToComplete', '?')} min",
        f"- **URL:** https://datadriven.io/problems/{slug}",
        "", "## Problem", "", ch["scenario"].get("problemStatement", ""),
    ]
    tested = (ch.get("concepts") or {}).get("tested") or []
    if tested:
        out += ["", "**Concepts tested:** " + ", ".join(f"`{c}`" for c in tested)]
    reqs = grading.get("businessRequirements") or []
    if reqs:
        out += ["", "## Requirements", ""] + [f"- {r['stakeholderVoicedRequirement']}" for r in reqs]
    gates = grading.get("structuralGates") or []
    if gates:
        out += ["", "## Must-have components", ""] + [f"- {g['explanationWhenFailed']}" for g in gates]
    stages = ((ch["scenario"].get("domainSpecific") or {}).get("pipeline_architecture") or {}).get("expectedPipelineStageNames")
    if stages:
        out += ["", "**Expected stages:** " + " → ".join(f"`{s}`" for s in stages)]
    blocks = (ch.get("deepDiveContent") or {}).get("blocks") or []
    if blocks:
        out += ["", "## Solution walkthrough", ""] + ["\n" + render_block(b) for b in blocks]
    return "\n".join(out).strip() + "\n"


def scrape(slug):
    try:
        ch = extract_challenge(fetch(f"https://datadriven.io/problems/{slug}"))
    except Exception as e:
        return slug, None, str(e)
    if not ch or (ch.get("catalog") or {}).get("domain") not in DOMAINS:
        return slug, None, None
    return slug, ch, None


def main():
    xml = fetch("https://datadriven.io/sitemap/3.xml")
    slugs = sorted(set(re.findall(r"problems/([^<]+)</loc>", xml)))
    for d in DOMAINS.values():
        (OUT / d).mkdir(parents=True, exist_ok=True)
    counts, errors = {}, []
    with ThreadPoolExecutor(8) as pool:
        for slug, ch, err in pool.map(scrape, slugs):
            if err:
                errors.append((slug, err))
            if not ch:
                continue
            name = re.sub(r'[\\/:*?"<>|\r\n\t]', "", ch["catalog"]["title"]).strip(". ")[:120]
            folder = DOMAINS[ch["catalog"]["domain"]]
            (OUT / folder / f"{name}.md").write_text(build_md(ch, slug), encoding="utf-8")
            counts[folder] = counts.get(folder, 0) + 1
    print(counts, f"errors={len(errors)}", errors[:5])


if __name__ == "__main__":
    main()
