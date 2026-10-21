# Contributing

## Setting up the development environment

1. Clone the repository from GitHub.
2. Install [HEMTT](https://hemtt.dev/):

    ```cmd
    winget install hemtt
    ```

3. Build the mod with `hemtt build`, or validate it without building via `hemtt check`.
4. `hemtt launch` starts Arma 3 with the mod. The test range mission `.hemtt/missions/itc_land_vr_test.VR` has a station for every system and a control board for teleports, scenarios and diagnostics.

## Coding guidelines

This mod follows the same [coding guidelines as the ACE3 mod](https://ace3.acemod.org/wiki/development/coding-guidelines) — naming conventions, function headers, bracket/spacing style, and the general avoidance of scheduled space (`spawn`/`execVM`) and magic numbers.

- User-facing text goes in the addon's `stringtable.xml` (`CSTRING` in configs, `LLSTRING` in scripts). Run `hemtt ln sort` after adding keys.
- Never put macros inside quoted strings, the preprocessor does not expand them there; use `QUOTE(...)` or the `Q`-prefixed macros.

## Validating changes

Before opening a PR, run:

```cmd
hemtt check
python tools/stringtable_validator.py
python tools/config_style_checker.py
python tools/macro_in_string_checker.py
```

These mirror the checks run in CI (`.github/workflows/check.yml` and `validate.yml`). Lint severities are set in `.hemtt/lints.toml`.

## Translations

All player-facing text is in the `stringtable.xml` of each addon. Only English exists so far; add your language as a new element next to `<English>` in every key.

## Documentation

The documentation is built with [MkDocs Material](https://squidfunk.github.io/mkdocs-material/) from the `docs` folder:

```cmd
pip install -r docs/requirements.txt
mkdocs serve
```

Pushes to `master` that change the docs publish them to GitHub Pages (`.github/workflows/docs.yml`). Add a new vehicle or item with its classname to the page of its system in `docs/systems/`, and new config for modders to [Mission Makers & Modders](scripting.md).

The open work list is `docs/TODO.md`; it is kept out of the published site.
