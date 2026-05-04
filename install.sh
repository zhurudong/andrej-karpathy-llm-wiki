#!/usr/bin/env bash
set -euo pipefail

DIR="${1:-my-knowledge-base}"
LANG_CHOICE="${2:-en}"

case "$LANG_CHOICE" in
  en) TEMPLATE="CLAUDE.en.md" ;;
  zh) TEMPLATE="CLAUDE.md" ;;
  *)
    echo "Unknown language: $LANG_CHOICE (use 'en' or 'zh')" >&2
    exit 1
    ;;
esac

echo "→ Creating knowledge base at: $DIR (lang: $LANG_CHOICE)"
mkdir -p "$DIR" && cd "$DIR"

mkdir -p raw raw/assets \
         wiki/summaries wiki/entities wiki/concepts \
         wiki/comparisons wiki/overviews wiki/synthesis

curl -fsSL -o CLAUDE.md \
  "https://raw.githubusercontent.com/zhurudong/andrej-karpathy-llm-wiki/main/templates/$TEMPLATE"

ln -sf CLAUDE.md AGENTS.md
touch wiki/_index.md wiki/_log.md

echo "✅ Done. Now run your LLM CLI inside: $DIR"
echo "   Then say: ingest https://your-favorite-article.com"
