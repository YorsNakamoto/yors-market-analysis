#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#  DEPLOY OTOMATIS — Yors Market Analysis v5 → GitHub Pages
#  Jalankan:  bash DEPLOY.sh
#  Butuh login GitHub sekali (kode akan muncul di layar).
# ═══════════════════════════════════════════════════════════════
set -e
REPO_NAME="yors-market-analysis"
DIR="$(cd "$(dirname "$0")" && pwd)"

echo "── 1/5 Cek login GitHub ──"
if ! gh auth status >/dev/null 2>&1; then
  echo "Butuh login GitHub (sekali saja)."
  gh auth login --hostname github.com --git-protocol https --web
fi
GH_USER=$(gh api user --jq .login)
echo "✅ Login sebagai: $GH_USER"

echo "── 2/5 Buat repo (bila belum ada) ──"
if ! gh repo view "$GH_USER/$REPO_NAME" >/dev/null 2>&1; then
  gh repo create "$REPO_NAME" --public --description "📊 Yors Market Analysis v5 — XAU/USD trading analysis (technical + fundamental + backtest)" || true
  echo "✅ Repo dibuat: $GH_USER/$REPO_NAME"
else
  echo "ℹ️  Repo sudah ada"
fi

echo "── 3/5 Commit & push ──"
cd "$DIR"
if [ ! -d .git ]; then git init -b main >/dev/null; fi
git add index.html README.md .nojekyll
git commit -m "Yors Market Analysis v5 — unified ctx scoring, DST-aware sessions, calendar, circuit breaker, backtest replay" >/dev/null 2>&1 || echo "ℹ️  Tidak ada perubahan baru"
git remote remove origin >/dev/null 2>&1 || true
git remote add origin "https://github.com/$GH_USER/$REPO_NAME.git"
git push -u origin main --force

echo "── 4/5 Aktifkan GitHub Pages ──"
gh api --method POST "repos/$GH_USER/$REPO_NAME/pages" -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 \
  || gh api --method PUT "repos/$GH_USER/$REPO_NAME/pages" -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 \
  || echo "⚠️  Aktifkan Pages manual: Settings → Pages → Branch: main"

echo "── 5/5 Selesai ──"
echo ""
echo "🌐 WEB ANDA: https://$GH_USER.github.io/$REPO_NAME/"
echo "   (online ±1-2 menit setelah pesan ini)"
echo ""
