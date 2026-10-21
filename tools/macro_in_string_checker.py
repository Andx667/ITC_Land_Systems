#!/usr/bin/env python3

import os
import re
import sys

# MACRO IN STRING CHECKER
# -----------------------
# The preprocessor never expands macros inside quoted strings, so a value like
# "[] call FUNC(foo)" reaches the game literally and fails at runtime.
# `hemtt check` does not catch this. Flags CBA/ACE macros found inside string
# literals in .sqf/.hpp/.cpp files under addons/.
#
# Replace with a HEMTT TOML lint (.hemtt/lints/*.toml) once a HEMTT release
# after 1.22.0 supports them.

MACROS = r"(?:Q{0,2}E?FUNC|Q{0,2}E?GVAR|E?C?STRING|L?LSTRING|Q?PATHTO(?:E?F)?|QUOTE|LINKFUNC)"
# A string that opens after =, (, [ or , so the match cannot start at a closing quote
PATTERN = re.compile(r'[=(\[,]\s*"[^"\r\n]*\b' + MACROS + r'\([^"\r\n]*"')
COMMENTS = re.compile(r"/\*.*?\*/|//[^\n]*", re.S)


def blank_comments(text):
    # Keep newlines so line numbers stay correct
    return COMMENTS.sub(lambda m: re.sub(r"[^\n]", " ", m.group(0)), text)


def check_file(filepath):
    with open(filepath, encoding="utf-8", errors="ignore") as f:
        text = blank_comments(f.read())
    errors = 0
    for match in PATTERN.finditer(text):
        line = text.count("\n", 0, match.start()) + 1
        print("  ERROR: {}:{}: macro inside a string literal: {}".format(filepath, line, match.group(0).strip()))
        errors += 1
    return errors


def main():
    root_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "addons")
    root_dir = os.path.normpath(root_dir)
    errors = 0
    for root, _, files in os.walk(root_dir):
        for name in sorted(files):
            if name.endswith((".sqf", ".hpp", ".cpp")):
                errors += check_file(os.path.relpath(os.path.join(root, name)))

    if errors == 0:
        print("Macro In String Check PASSED")
    else:
        print("Macro In String Check FAILED: {} problem(s)".format(errors))
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
