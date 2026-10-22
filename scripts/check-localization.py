"""Release gate for Despacer's languages: the app and the docs.

Usage: scripts/check-localization.py [--lang de] [--skip-extract]

  App      Every string the code shows is a key in Localization/en.lproj (found by
           compiling App/ and Sources/DespacerCore/ with -emit-localized-strings),
           and every other .lproj has exactly the same keys, translated: same
           format arguments, protected names kept, no em dash, no "Mac"/"macOS" a
           source string didn't have, and not just the English copied over.
           Info.plist's CFBundleLocalizations lists exactly those languages.
  Docs     README.<lang>.md and PRIVACY.<lang>.md exist and are translated, every
           README carries the full language bar, and every relative link and
           in-page anchor resolves. No em dashes (the docs are user facing).

Exits non-zero with every problem listed.
"""

import argparse
import json
import re
import subprocess
import sys
import tempfile
import unicodedata
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
LOC = ROOT / "Localization"
LANGUAGES = ["en", "de", "es", "fr", "ja", "ko", "pt-BR", "zh-Hans", "zh-Hant"]

EM_DASH = "—"
# "Mac" or "macOS" as a word. ASCII-letter boundaries, because \b never fires
# between "Mac" and a CJK character ("Macの").
MAC = re.compile(r"(?<![A-Za-z])mac(?:os)?(?![A-Za-z])", re.IGNORECASE)
FORMAT = re.compile(r"%(?:\d+\$)?[@dDuUxXoOfeEgGcCsSpaAF%]")
# Names that must survive translation untouched wherever the English has them.
PROTECTED = ["Despacer", "Claude Code", "Codex", "Matt Senter", "Senternet", "Cmd+H", "Slack",
             ":emoji:", "CommandH", "Weatherling", "Burly", "Comoji", "Premail", "Highwire",
             "StockCar", "Orgabot", "Fix Siri", "BeeReady", "SeedMatrix", "Hey Siri, do better."]
PROTECTED_RENAMED = {}
# Keys whose translation may legitimately equal the English in some language.
MAY_MATCH_ENGLISH = {"Version", "Version %@", "System", "Copyright © 2026 %@",
                     "Privacy", "About", "Terminals"}

DOCS = ("README", "PRIVACY")

problems = []


def problem(message):
    problems.append(message)


def doc_name(stem, lang):
    return f"{stem}.md" if lang == "en" else f"{stem}.{lang}.md"


def read_strings(path):
    """A .strings file as a dict, parsed by plutil so escapes are handled exactly."""
    out = subprocess.run(["plutil", "-convert", "json", "-o", "-", str(path)],
                         capture_output=True, text=True)
    if out.returncode != 0:
        problem(f"{path.relative_to(ROOT)} does not parse: {out.stderr.strip()}")
        return {}
    return json.loads(out.stdout)


def source_keys():
    """Every localizable string the app shows."""
    keys = set()
    sources = sorted(str(p) for p in [*(ROOT / "App").glob("*.swift"), *(ROOT / "Sources/DespacerCore").glob("*.swift")])
    for flags in ([],):
        with tempfile.TemporaryDirectory() as tmp:
            result = subprocess.run(
                ["swiftc", "-c", "-swift-version", "5", "-module-name", "Despacer", *flags,
                 "-emit-localized-strings", "-emit-localized-strings-path", tmp, *sources],
                cwd=tmp, capture_output=True, text=True)
            if result.returncode != 0:
                sys.exit(f"swiftc failed:\n{result.stderr}")
            for data in Path(tmp).glob("*.stringsdata"):
                for entries in json.loads(data.read_text()).get("tables", {}).values():
                    keys.update(entry["key"] for entry in entries)
    return keys


def normalized(text):
    return re.sub(r"\s+", " ", text).strip().lower()


# MARK: App

def check_app(langs, extract):
    english = read_strings(LOC / "en.lproj" / "Localizable.strings")
    if extract:
        used = source_keys()
        for key in sorted(used - english.keys()):
            problem(f"en.lproj is missing a string the app shows: {key!r}")
        for key in sorted(english.keys() - used):
            problem(f"en.lproj has a key the app no longer uses: {key!r}")

    on_disk = {p.name.removesuffix(".lproj") for p in LOC.glob("*.lproj")}
    for lang in sorted(on_disk - set(LANGUAGES)):
        problem(f"Localization/{lang}.lproj exists but {lang} is not in LANGUAGES")

    info = subprocess.run(["plutil", "-extract", "CFBundleLocalizations", "json", "-o", "-",
                           str(ROOT / "Info.plist")], capture_output=True, text=True)
    declared = set(json.loads(info.stdout)) if info.returncode == 0 else set()
    if declared != set(LANGUAGES):
        problem(f"Info.plist CFBundleLocalizations {sorted(declared)} != languages {sorted(LANGUAGES)}")

    for lang in langs:
        if lang == "en":
            continue
        path = LOC / f"{lang}.lproj" / "Localizable.strings"
        if not path.exists():
            problem(f"Missing {path.relative_to(ROOT)}")
            continue
        strings = read_strings(path)
        for key in sorted(english.keys() - strings.keys()):
            problem(f"{lang}: missing {key!r}")
        for key in sorted(strings.keys() - english.keys()):
            problem(f"{lang}: stale key {key!r}")
        for key, value in strings.items():
            if key not in english:
                continue
            where = f"{lang}: {key!r}"
            if not value.strip():
                problem(f"{where} is empty")
            if sorted(FORMAT.findall(value)) != sorted(FORMAT.findall(key)):
                problem(f"{where} has format arguments {FORMAT.findall(value)}, expected {FORMAT.findall(key)}")
            if EM_DASH in value:
                problem(f"{where} contains an em dash")
            if MAC.search(value) and not MAC.search(key):
                problem(f"{where} adds Mac/macOS wording: {value!r}")
            for name in PROTECTED:
                if name in key and PROTECTED_RENAMED.get((name, lang), name) not in value:
                    problem(f"{where} drops {name!r}: {value!r}")
            if value == key and key not in MAY_MATCH_ENGLISH:
                problem(f"{where} is untranslated")


# MARK: Docs

def github_slug(heading):
    """GitHub's anchor for a Markdown heading."""
    text = re.sub(r"<[^>]+>", "", heading)
    text = re.sub(r"[`*_]|\[([^\]]*)\]\([^)]*\)", lambda m: m.group(1) or "", text).strip().lower()
    kept = []
    for ch in text:
        cat = unicodedata.category(ch)
        if ch in "-_" or ch == " " or cat[0] in "LNM":
            kept.append("-" if ch == " " else ch)
    return "".join(kept)


def check_markdown(path):
    text = path.read_text()
    name = path.relative_to(ROOT)
    if EM_DASH in text:
        problem(f"{name} contains an em dash")
    prose = re.sub(r"```.*?```", "", text, flags=re.S)
    anchors, counts = set(), {}
    for heading in re.findall(r"^#{1,6}\s+(.+?)\s*$", prose, re.M):
        slug = github_slug(heading)
        n = counts.get(slug, 0)
        counts[slug] = n + 1
        anchors.add(slug if n == 0 else f"{slug}-{n}")
    targets = re.findall(r"\]\(([^)\s]+)\)", prose) + re.findall(r'(?:href|src)="([^"]+)"', prose)
    for target in targets:
        if re.match(r"[a-z]+:", target):
            continue
        file, _, anchor = target.partition("#")
        if file and not (ROOT / file).exists():
            problem(f"{name}: broken link {target}")
        if not file and anchor and anchor not in anchors:
            problem(f"{name}: no heading for #{anchor}")
    return text


def check_docs(langs):
    english = {stem: (ROOT / doc_name(stem, "en")).read_text() for stem in DOCS}
    bar = [doc_name("README", lang) for lang in LANGUAGES]
    for lang in langs:
        for stem in DOCS:
            path = ROOT / doc_name(stem, lang)
            if not path.exists():
                problem(f"Missing {path.name}")
                continue
            text = check_markdown(path)
            if lang != "en" and normalized(text) == normalized(english[stem]):
                problem(f"{path.name} is the English text")
            if stem == "README":
                head = text[:2500]
                for other in bar:
                    if other != path.name and f"({other})" not in head and f'"{other}"' not in head:
                        problem(f"{path.name}: language bar does not link {other}")


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--lang", action="append", help="check only these app languages (repeatable)")
    parser.add_argument("--skip-extract", action="store_true", help="don't compile the app to find its strings")
    args = parser.parse_args()
    langs = args.lang or list(LANGUAGES)
    for lang in langs:
        if lang not in LANGUAGES:
            sys.exit(f"{lang} is not in LANGUAGES")

    check_app(langs, extract=not args.skip_extract)
    check_docs(langs)

    if problems:
        print("\n".join(problems))
        print(f"\n{len(problems)} localization problem(s).")
        sys.exit(1)
    print(f"Localization OK: {', '.join(langs)}")


if __name__ == "__main__":
    main()
