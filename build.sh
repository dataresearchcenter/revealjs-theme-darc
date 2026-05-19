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

# Stage our SCSS into reveal.js/css/theme/ (idempotent — copy source-of-truth)
cp src/darc.scss       reveal.js/css/theme/darc.scss
cp src/darc-light.scss reveal.js/css/theme/darc-light.scss

# Install deps once
if [ ! -d reveal.js/node_modules ]; then
	(cd reveal.js && npm install --no-audit --no-fund)
fi

# Compile via reveal.js's vite styles config
(cd reveal.js && npm run build:styles)

# Copy compiled CSS to top-level dist/
mkdir -p dist
cp reveal.js/dist/theme/darc.css       dist/darc.css
cp reveal.js/dist/theme/darc-light.css dist/darc-light.css

echo
echo "Built:"
ls -la dist/darc*.css
