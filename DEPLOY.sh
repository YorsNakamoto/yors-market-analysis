#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#  🚀 DEPLOY SATU PERINTAH — Yors Market Analysis v5 → GitHub Pages
#
#  Cara pakai (di Terminal Mac):
#      cd "/Users/nab/Documents/TRADING TOOLS/yors-web"
#      bash DEPLOY.sh
#
#  Yang terjadi:
#   1. Login GitHub (SEKALI saja) — kode akan muncul di Terminal,
#      browser terbuka otomatis → masukkan kode → Authorize.
#   2. Repo dibuat otomatis: yors-market-analysis (public)
#   3. File di-push, GitHub Pages diaktifkan.
#   4. Website online di:  https://<username>.github.io/yors-market-analysis/
# ═══════════════════════════════════════════════════════════════
set -e
export PATH="$HOME/bin:$PATH"
GH="$(command -v gh || echo "$HOME/bin/gh")"
DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="yors-market-analysis"

echo "═══ Yors Market Analysis v5 — Deploy ═══"

if [ ! -x "$GH" ]; then
  echo "❌ gh CLI tidak ditemukan. Install: brew install gh  (atau unduh dari github.com/cli/cli)"
  exit 1
fi

echo "── 1/5 Cek login GitHub ──"
if ! "$GH" auth status >/dev/null 2>&1; then
  echo "→ Butuh login GitHub (sekali saja). Ikuti instruksi di layar…"
  "$GH" auth login --hostname github.com --git-protocol https --web
fi
GH_USER=$("$GH" api user --jq .login)
echo "✅ Login sebagai: $GH_USER"

echo "── 2/5 Buat repo $GH_USER/$REPO ──"
if ! "$GH" repo view "$GH_USER/$REPO" >/dev/null 2>&1; then
  "$GH" repo create "$REPO" --public --description "📊 Yors Market Analysis v5 — XAU/USD (technical + fundamental + backtest)" && echo "✅ Repo dibuat"
else
  echo "ℹ️  Repo sudah ada — akan diperbarui"
fi

echo "── 3/5 Commit versi terbaru ──"
cd "$DIR"
# pastikan index.html adalah versi terbaru dari file master
if [ -f "../Yors_Market_Analysis_v5.html" ]; then cp "../Yors_Market_Analysis_v5.html" index.html; fi
git add -A
git -c user.name="Yors" -c user.email="yors@local" commit -m "Yors Market Analysis v5 deploy" >/dev/null 2>&1 || echo "ℹ️  Tidak ada perubahan baru"
git remote remove origin >/dev/null 2>&1 || true
git remote add origin "https://github.com/$GH_USER/$REPO.git"

echo "── 4/5 Push + aktifkan GitHub Pages ──"
git push -u origin main --force
"$GH" api --method POST "repos/$GH_USER/$REPO/pages" -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 \
  || "$GH" api --method PUT "repos/$GH_USER/$REPO/pages" -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 \
  || echo "⚠️  Aktifkan Pages manual: repo → Settings → Pages → Branch: main → Save"

echo "── 5/5 Selesai ═══"
echo ""
echo "🌐 WEB ANDA: https://$GH_USER.github.io/$REPO/"
echo "   Online dalam ±1–2 menit. Bookmark URL tersebut."
echo ""
