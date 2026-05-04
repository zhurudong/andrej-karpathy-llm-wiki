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

cat <<EOF

✅ Done. Next steps:

  1. Enter the knowledge base:
       cd $DIR

  2. Launch your LLM CLI in that directory (pick one):
       claude          # Claude Code   — reads CLAUDE.md
       codex           # Codex CLI     — reads AGENTS.md (already symlinked)
       opencode        # OpenCode      — reads AGENTS.md

  3. Try the sample article:
       ingest https://www.anthropic.com/engineering/harness-design-long-running-apps

EOF
