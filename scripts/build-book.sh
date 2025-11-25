#!/usr/bin/env bash
set -euo pipefail

# Always run from the repo root (one level up from this script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}/.."
cd "$REPO_ROOT"

# Paths
DIST_DIR="dist"
METADATA_FILE="build/pandoc/metadata.yaml"
COVER_IMAGE="assets/img/book-cover.png"

mkdir -p "$DIST_DIR"

# Sanity checks
if [[ ! -f "$METADATA_FILE" ]]; then
  echo "ERROR: metadata file not found at $METADATA_FILE"
  exit 1
fi

if [[ ! -f "$COVER_IMAGE" ]]; then
  echo "ERROR: cover image not found at $COVER_IMAGE"
  exit 1
fi

# Chapters in order
CHAPTERS=(
  "manuscript/00-frontmatter/cover.md"        # Page 1 – full cover
  "manuscript/00-frontmatter/title-page.md"   # Page 2 – title page
  "manuscript/00-frontmatter/contents.md"     # Page 3 – table of contents
  "manuscript/00-frontmatter/preface.md"
  "manuscript/01-on-language/index.md"
  "manuscript/02-the-metaphysic/index.md"
  "manuscript/03-frames-and-games/index.md"
  "manuscript/04-significant-frames/index.md"
  "manuscript/05-cosmogony/index.md"
  "manuscript/06-the-meta-frame-and-meta-game/index.md"
  "manuscript/07-mastery-of-the-meta-game/index.md"
  "manuscript/99-backmatter/notes.md"
)

PDF_OUTPUT="$DIST_DIR/the-collective-individual.pdf"
EPUB_OUTPUT="$DIST_DIR/the-collective-individual.epub"

echo "Building The Collective Individual..."

# Build PDF
pandoc \
  "${CHAPTERS[@]}" \
  --template=build/pandoc/templates/book.tex \
  --metadata-file="$METADATA_FILE" \
  --resource-path=".:assets:manuscript" \
  --pdf-engine=pdflatex \
  -o "$PDF_OUTPUT"

echo "✓ PDF built at $PDF_OUTPUT"

# Build EPUB (with cover)
pandoc \
  "${CHAPTERS[@]}" \
  --metadata-file="$METADATA_FILE" \
  --resource-path=".:assets:manuscript" \
  --toc --toc-depth=1 \
  --epub-cover-image="$COVER_IMAGE" \
  -o "$EPUB_OUTPUT"

echo "✓ EPUB built at $EPUB_OUTPUT"



# run 'bash ~/bin/syncfile.sh' in the macos terminal to sync changes to iCloud

echo "Done."
