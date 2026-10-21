# Contributing Setup & Guidelines

## Setting up the Development Environment

### 1. Clone the repository from GitHub

### 2. Install HEMTT

The latest version of HEMTT can be installed by running:

```cmd
winget install hemtt
```

## Coding Guidelines

This mod follows the same coding guidelines as the ACE3 mod, which can be found [here](https://ace3.acemod.org/wiki/development/coding-guidelines).

## Checks

CI runs these on every pull request; run them locally before pushing:

```cmd
hemtt check
python tools/stringtable_validator.py
python tools/config_style_checker.py
python tools/macro_in_string_checker.py
```

- Lint severities are set in `.hemtt/lints.toml`.
- User-facing text goes in the addon's `stringtable.xml` (`CSTRING` in configs, `LLSTRING` in scripts). Run `hemtt ln sort` after adding keys.
- Never put macros inside quoted strings, the preprocessor does not expand them there; use `QUOTE(...)` or the `Q`-prefixed macros.
