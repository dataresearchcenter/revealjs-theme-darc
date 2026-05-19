#!/usr/bin/env bash
# Build the DARC reveal.js themes and stage them at top-level dist/.
#
# Usage:  ./build.sh
#
# If reveal.js/ is missing, the pinned upstream tag is cloned automatically,
# so this script works on a fresh clone and in CI.

set -euo pipefail

# Pinned reveal.js version. Bump to track upstream theme-template changes.
REVEAL_TAG="${REVEAL_TAG:-6.0.1}"
REVEAL_REPO="${REVEAL_REPO:-https://github.com/hakimel/reveal.js.git}"

cd "$(dirname "$0")"

# Clone reveal.js at the pinned tag if it isn't already here
if [ ! -d reveal.js ]; then
	echo "→ cloning reveal.js @ ${REVEAL_TAG}"
	git clone --depth 1 --branch "${REVEAL_TAG}" "${REVEAL_REPO}" reveal.js
fi

# Stage reveal-themed SCSS into reveal.js/css/theme/ for vite to compile
cp src/darc.scss          reveal.js/css/theme/darc.scss
cp src/darc-light.scss    reveal.js/css/theme/darc-light.scss
cp src/darc-hedgedoc.scss reveal.js/css/theme/darc-hedgedoc.scss

# Install deps once
if [ ! -d reveal.js/node_modules ]; then
	(cd reveal.js && npm install --no-audit --no-fund)
fi

# Compile via reveal.js's vite styles config
(cd reveal.js && npm run build:styles)

# Copy vite-compiled CSS to top-level dist/
mkdir -p dist
cp reveal.js/dist/theme/darc.css          dist/darc.css
cp reveal.js/dist/theme/darc-light.css    dist/darc-light.css
cp reveal.js/dist/theme/darc-hedgedoc.css dist/darc-hedgedoc.css

# Compile darc-hedgedoc-slide.scss with sass CLI directly — vite's
# postcss-import would try to inline the `@import url("darc.css")` at
# build time, but we need that import preserved so the browser fetches
# /css/darc.css alongside slide.css at runtime.
reveal.js/node_modules/.bin/sass --no-source-map --style=compressed \
  src/darc-hedgedoc-slide.scss dist/darc-hedgedoc-slide.css

echo
echo "Built:"
ls -la dist/darc*.css
