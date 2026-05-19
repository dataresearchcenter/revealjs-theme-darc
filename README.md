# revealjs-theme-darc

DARC theme for **HedgeDoc** and **reveal.js** — orange ember accent on slate, Inter for body, Sligoil Micro for display + code. Adapted from the [DARC zensical / mkdocs-material theme](https://dataresearchcenter.github.io/zensical-theme-darc/).

Three stylesheets ship side-by-side:

| File | Target | Use for |
|---|---|---|
| `dist/darc.css` | reveal.js — slate (dark) | default deck theme |
| `dist/darc-light.css` | reveal.js — paper (light) | light-room presentations / handouts |
| `dist/darc-hedgedoc.css` | HedgeDoc app UI | retint editor, preview, cover, nav |

All three are published at `https://dataresearchcenter.github.io/revealjs-theme-darc/dist/` on every push to `main`.

## Use with HedgeDoc

For a self-hosted HedgeDoc deployment, bind-mount the relevant DARC stylesheet over HedgeDoc's stock CSS file. Both paths live under `/css/` which is already in HedgeDoc's `style-src` CSP allowlist.

### docker-compose.yml

```yaml
services:
  hedgedoc:
    volumes:
      # slide mode — replaces reveal.js theme
      - ./darc.css:/hedgedoc/public/css/slide.css:ro
      # app UI — replaces the tiny site-wide stylesheet (font, focus, scroll)
      - ./darc-hedgedoc.css:/hedgedoc/public/css/site.css:ro
```

Drop your local copies next to the compose file and restart. Pull fresh copies from the published Pages build with:

```sh
curl -o darc.css          https://dataresearchcenter.github.io/revealjs-theme-darc/dist/darc.css
curl -o darc-hedgedoc.css https://dataresearchcenter.github.io/revealjs-theme-darc/dist/darc-hedgedoc.css
```

Swap `darc.css` for `darc-light.css` if you want the paper slide variant.

### CSP whitelist

All three stylesheets `@import` fonts from `https://cdn.investigativedata.org`. HedgeDoc's defaults block both the stylesheet and the woff2 files, so add the CDN to two CSP directives in `config.json`:

```json
{
  "csp": {
    "directives": {
      "styleSrc": ["'self'", "'unsafe-inline'", "https://cdn.investigativedata.org"],
      "fontSrc":  ["'self'", "https://cdn.investigativedata.org"]
    }
  }
}
```

`styleSrc` lets `fonts.min.css` resolve through `@import`; `fontSrc` lets the woff2 files inside it load. Restart HedgeDoc after editing.

### What `darc-hedgedoc.css` actually retints

Palette-only overlay, not a structural redesign — HedgeDoc's Bootstrap-flavoured layout stays intact, but the following get DARC treatment:

- body font → Inter; `code` / `.CodeMirror` / `.navbar-brand` → Sligoil Micro
- `h1` (cover heading, markdown preview) → Sligoil Micro 400, tight tracking
- `h2`–`h6` → Inter 600, slight negative tracking
- links → orange ember; primary buttons + form focus rings → orange ember
- inline `code` chips → ember-tinted panel
- nav-pills active state, TOC active link, history hover → orange ember
- text selection → orange ember
- `:::block` admonition variants tinted (see below)

It does **not** restyle CodeMirror's syntax highlighting, the night-mode toggle, or HedgeDoc's structural chrome — that would be a full theme port.

### Admonitions

HedgeDoc's native `:::block` syntax renders as `<div class="alert alert-{variant}">…</div>` and picks up DARC's accent palette automatically:

```markdown
:::success
## All green
Yes :tada:
:::

:::info
## Heads up
Purple accent for notes.
:::

:::warning
## Caution
Yellow accent.
:::

:::danger
## Stop
Orange accent.
:::
```

The slide-mode stylesheet (`darc.css`) also accepts mkdocs `<aside class="admonition note">…</aside>` and bare bootstrap `<div class="alert alert-info">…</div>` for the same effect.

| HedgeDoc `:::` | mkdocs class | Bootstrap class | Accent |
|---|---|---|---|
| `:::info` | `note`, `info` | `alert-info` | purple |
| `:::warning` | `warning`, `caution` | `alert-warning` | yellow |
| `:::danger` | `danger`, `error`, `failure` | `alert-danger` | orange |
| `:::success` | `tip`, `success`, `hint` | `alert-success` | green |

## Use in a vanilla reveal.js deck

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@6.0.1/dist/reset.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@6.0.1/dist/reveal.css">
<link rel="stylesheet" href="https://dataresearchcenter.github.io/revealjs-theme-darc/dist/darc.css">
```

Replace the last `<link>` with `dist/darc-light.css` for the paper variant.

## Eyebrow / mono-tag

For DARC-style eyebrow labels above a heading (slide mode):

```html
<p class="eyebrow">section label</p>
<h1>Slide title</h1>
```

## Building

```sh
./build.sh
```

The script will:
1. Clone reveal.js at the pinned tag (`6.0.1`) into `reveal.js/` if not present.
2. Copy `src/darc.scss`, `src/darc-light.scss`, and `src/darc-hedgedoc.scss` into `reveal.js/css/theme/`.
3. Run `npm run build:styles` inside the reveal.js checkout.
4. Stage compiled CSS into top-level `dist/`.

To bump reveal.js: `REVEAL_TAG=6.x.y ./build.sh` (or edit the default in `build.sh`).

## Repo layout

```
src/                    DARC theme SCSS — source of truth
  darc.scss             reveal.js — slate (dark) variant
  darc-light.scss       reveal.js — paper (light) variant
  darc-hedgedoc.scss    HedgeDoc — app UI palette overlay
dist/                   compiled CSS, served via GitHub Pages
index.html              demo deck (also published)
build.sh                build script (clones reveal.js, runs vite)
.github/workflows/      Pages deploy
reveal.js/              gitignored — cloned at build time
```

## Acknowledgements

- Upstream framework: [reveal.js by Hakim El Hattab](https://revealjs.com).
- Palette + type system: [DARC zensical theme](https://github.com/dataresearchcenter/zensical-theme-darc).
- Sligoil Micro by [Ariel Martín Pérez / Velvetyne](https://velvetyne.fr/fonts/sligoil/).
- Inter by [Rasmus Andersson](https://rsms.me/inter/).
