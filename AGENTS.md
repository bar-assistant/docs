# AGENTS.md

Bar Assistant documentation site built with MkDocs + Material theme.

## Local development

### Docker (recommended)

```bash
docker compose up
```

Site available at `http://localhost:8000`. The source directory is bind-mounted for hot-reload.

### Python

```bash
pip install mkdocs-material
mkdocs serve
```

## Deployment

- GitHub Actions deploys on push to `main` via `mkdocs gh-deploy --force`
- Published to `https://bar-assistant.github.io/docs`

## Content notes

- Custom theme overrides live in `overrides/`
- External links in nav (OpenAPI Spec, changelogs) point to live URLs, not local files
- Deployment branch for GitHub Pages is `gh-pages` (managed by `mkdocs gh-deploy`)