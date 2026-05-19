# revealjs-darc-theme

A reveal.js port of the [DARC zensical / mkdocs-material theme](https://dataresearchcenter.github.io/zensical-theme-darc/) — orange ember accent on slate, Inter for body, Sligoil Micro for display + code.

Two variants ship side-by-side:

| File | Background | Use for |
|---|---|---|
| `dist/darc.css` | near-black (slate) | default — recommended for slide decks |
| `dist/darc-light.css` | DARC paper | light-room presentations / handouts |

## Use with HedgeDoc

For a self-hosted HedgeDoc deployment, the cleanest path is to **replace HedgeDoc's stock `public/css/slide.css` with `dist/darc.css`**. That URL is already in HedgeDoc's `style-src` CSP allowlist, applies to every deck automatically, and needs no per-document markup.

### Docker bind-mount

```yaml
# docker-compose.yml
services:
  hedgedoc:
    volumes:
      - ./darc.css:/hedgedoc/public/css/slide.css:ro
```

Drop your local copy of `dist/darc.css` next to the compose file and restart. Every slide deck now renders with the DARC theme. Swap for `darc-light.css` if you want the paper variant.

To pull a fresh copy from the published Pages build:

```sh
curl -o darc.css https://dataresearchcenter.github.io/revealjs-theme-darc/dist/darc.css
```

### Font CSP whitelist

`darc.css` loads Inter + Sligoil Micro from `https://cdn.investigativedata.org`. HedgeDoc's default `font-src` is `'self'` only, so without one extra line in `config.json` the slides render with system fallback fonts:

```json
{
  "csp": {
    "directives": {
      "fontSrc": ["'self'", "https://cdn.investigativedata.org"]
    }
  }
}
```

Restart HedgeDoc after editing.

### Admonitions in HedgeDoc

HedgeDoc has native `:::block` syntax that maps straight onto DARC's accent palette:

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

These render as `<div class="alert alert-{variant}">…</div>` and the DARC stylesheet tints them per-variant.

## Use in a vanilla reveal.js deck

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@6.0.1/dist/reset.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@6.0.1/dist/reveal.css">
<link rel="stylesheet" href="https://dataresearchcenter.github.io/revealjs-theme-darc/dist/darc.css">
```

## Admonitions

Three input syntaxes are styled — pick whichever your editor likes best.

**HedgeDoc native** (recommended in HedgeDoc decks):

```markdown
:::success
## Heading
Body text.
:::
```

**mkdocs / zensical HTML** (works in any markdown that allows raw HTML):

```html
<aside class="admonition note">
  <span class="admonition-title">Note</span>
  <p>Mirror of the DARC mkdocs callout.</p>
</aside>
```

**Plain bootstrap-style div**:

```html
<div class="alert alert-info">
  <h4>Heading</h4>
  Body text.
</div>
```

Accent per variant:

| HedgeDoc `:::` | mkdocs class | Bootstrap class | Accent |
|---|---|---|---|
| `:::info` | `note`, `info` | `alert-info` | purple |
| `:::warning` | `warning`, `caution` | `alert-warning` | yellow |
| `:::danger` | `danger`, `error`, `failure` | `alert-danger` | orange |
| `:::success` | `tip`, `success`, `hint` | `alert-success` | green |

## Eyebrow / mono-tag

For DARC-style eyebrow labels above a heading:

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
2. Copy `src/darc.scss` and `src/darc-light.scss` into `reveal.js/css/theme/`.
3. Run `npm run build:styles` inside the reveal.js checkout.
4. Stage compiled CSS into top-level `dist/`.

To bump reveal.js: `REVEAL_TAG=6.x.y ./build.sh` (or edit the default in `build.sh`).

## Repo layout

```
src/                    DARC theme SCSS — source of truth
  darc.scss             slate (dark) variant
  darc-light.scss       paper (light) variant
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
