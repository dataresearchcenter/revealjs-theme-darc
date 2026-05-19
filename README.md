# revealjs-darc-theme

A reveal.js port of the [DARC zensical / mkdocs-material theme](https://dataresearchcenter.github.io/zensical-theme-darc/) — orange ember accent on slate, Inter for body, Sligoil Micro for display + code.

Two variants ship side-by-side:

| File | Background | Use for |
|---|---|---|
| `dist/darc.css` | near-black (slate) | default — recommended for slide decks |
| `dist/darc-light.css` | DARC paper | light-room presentations / handouts |

## Use with HedgeDoc

HedgeDoc's `slideOptions.theme` only accepts named built-in reveal.js themes, so we side-load DARC via a `<link>` in the slide markdown:

```markdown
---
title: My deck
type: slide
slideOptions:
  theme: black            # any built-in is fine — DARC overrides everything
  transition: fade
---

<link rel="stylesheet" href="https://<your-gh-pages-url>/dist/darc.css">

# Slide one

Body text.
```

The `<link>` is parsed as raw HTML and applies the DARC overrides on top of whatever HedgeDoc loaded. Drop in `dist/darc-light.css` instead for the light variant.

## Use in a vanilla reveal.js deck

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@6.0.1/dist/reset.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@6.0.1/dist/reveal.css">
<link rel="stylesheet" href="https://<your-gh-pages-url>/dist/darc.css">
```

## Admonitions

The theme styles DARC-flavoured admonition blocks. Markdown doesn't define them, but you can write raw HTML inside slide content:

```html
<aside class="admonition note">
  <span class="admonition-title">Note</span>
  <p>Mirror of the DARC mkdocs callout.</p>
</aside>
```

Variants and their accents:

| Class | Accent |
|---|---|
| `note`, `info` | purple |
| `warning`, `caution` | yellow |
| `danger`, `error`, `failure` | orange |
| `tip`, `success`, `hint` | green |

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
