#!/usr/bin/env python3

import os
import re
import sys

# MACRO IN STRING CHECKER
# -----------------------
# The preprocessor never expands macros inside double-quoted strings, so a value like
# "[] call FUNC(foo)" or "(0.3 + POSXADJUST) * safezoneW" reaches the game literally
# and fails at runtime. `hemtt check` does not catch this. Flags, inside double-quoted
# string literals in .sqf/.hpp/.cpp files under addons/:
#   - CBA/ACE macros (FUNC(...), GVAR(...), QUOTE(...), ...)
#   - any macro #defined in this project (e.g. POSXADJUST)
# Single-quoted text is not checked: the preprocessor does expand macros inside it.
#
# Replace with a HEMTT TOML lint (.hemtt/lints/*.toml) once a HEMTT release
# after 1.22.0 supports them.

CBA_MACROS = re.compile(r"\b(?:Q{0,2}E?FUNC|Q{0,2}E?GVAR|E?C?STRING|L?LSTRING|Q?PATHTO(?:E?F)?|QUOTE|LINKFUNC)\(")
DEFINE = re.compile(r"^\s*#define\s+(\w+)", re.M)
EXTENSIONS = (".sqf", ".hpp", ".cpp")


def strings(text):
    """Yield (line, content) for every double-quoted string literal, skipping comments,
    single-quoted strings and #include paths. "" inside a string is an escaped quote."""
    i, n, line = 0, len(text), 1
    while i < n:
        c = text[i]
        if c == "\n":
            line += 1
            i += 1
        elif text.startswith("//", i):
            i = text.find("\n", i)
            i = n if i < 0 else i
        elif text.startswith("/*", i):
            end = text.find("*/", i + 2)
            end = n if end < 0 else end + 2
            line += text.count("\n", i, end)
            i = end
        elif text.startswith("#include", i):
            i = text.find("\n", i)
            i = n if i < 0 else i
        elif c in "\"'":
            start, start_line, j = i + 1, line, i + 1
            while j < n:
                if text[j] == c:
                    if j + 1 < n and text[j + 1] == c:
                        j += 2
                        continue
                    break
                j += 1
            content = text[start:j]
            line += content.count("\n")
            if c == '"':
                yield start_line, content
            i = j + 1
        else:
            i += 1


def project_defines(root_dir):
    names = set()
    for root, _, files in os.walk(root_dir):
        for name in files:
            if name.endswith(EXTENSIONS):
                with open(os.path.join(root, name), encoding="utf-8", errors="ignore") as f:
                    names.update(DEFINE.findall(f.read()))
    return names


def check_file(filepath, defines_re):
    with open(filepath, encoding="utf-8", errors="ignore") as f:
        text = f.read()
    errors = 0
    for line, content in strings(text):
        found = CBA_MACROS.search(content) or (defines_re and defines_re.search(content))
        if found:
            print("  ERROR: {}:{}: macro {} inside a string literal: \"{}\"".format(
                filepath, line, found.group(0).rstrip("("), content.strip()[:100]))
            errors += 1
    return errors


def main():
    root_dir = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "addons"))
    names = project_defines(root_dir)
    defines_re = re.compile(r"\b(?:" + "|".join(sorted(map(re.escape, names))) + r")\b") if names else None
    errors = 0
    for root, _, files in os.walk(root_dir):
        for name in sorted(files):
            if name.endswith(EXTENSIONS):
                errors += check_file(os.path.relpath(os.path.join(root, name)), defines_re)

    if errors == 0:
        print("Macro In String Check PASSED")
    else:
        print("Macro In String Check FAILED: {} problem(s)".format(errors))
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
