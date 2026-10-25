#!/bin/bash
# AUTO-DEPLOY: auth GitHub (device flow) → buat repo → push → aktifkan Pages
# Output: DEPLOY_RESULT.txt berisi URL final / status error
DIR="$(cd "$(dirname "$0")" && pwd)"
export HOME="$HOME"
GH="$HOME/bin/gh"
RESULT="$DIR/DEPLOY_RESULT.txt"
CODE_FILE="$DIR/AUTH_CODE.txt"
: > "$RESULT"

echo "[1/5] Login GitHub (device flow)..." >> "$RESULT"

if ! $GH auth status >/dev/null 2>&1; then
  # --insecure-storage: token disimpan di file config (hindari prompt keychain macOS)
  $GH auth login --hostname github.com --git-protocol https --web --insecure-storage || {
    echo "ERROR: login gagal / dibatalkan." >> "$RESULT"; exit 1; }
fi
echo "[1/5] Login OK" >> "$RESULT"

GH_USER=$($GH api user --jq .login)
[ -z "$GH_USER" ] && { echo "ERROR: gagal ambil username" >> "$RESULT"; exit 1; }
echo "[2/5] User: $GH_USER" >> "$RESULT"

if ! $GH repo view "$GH_USER/yors-market-analysis" >/dev/null 2>&1; then
  $GH repo create "yors-market-analysis" --public --description "📊 Yors Market Analysis v5 — XAU/USD trading analysis (technical + fundamental + backtest)" >> "$RESULT" 2>&1
fi
echo "[3/5] Repo siap" >> "$RESULT"

cd "$DIR"
git add -A >/dev/null 2>&1
git -c user.name="Yors" -c user.email="yors@local" commit -m "Yors Market Analysis v5 deploy" >/dev/null 2>&1 || true
git remote remove origin >/dev/null 2>&1 || true
git remote add origin "https://github.com/$GH_USER/yors-market-analysis.git"
git push -u origin main --force >> "$RESULT" 2>&1
echo "[4/5] Push selesai" >> "$RESULT"

$GH api --method POST "repos/$GH_USER/yors-market-analysis/pages" -f "source[branch]=main" -f "source[path]=/" >> "$RESULT" 2>&1 \
  || $GH api --method PUT "repos/$GH_USER/yors-market-analysis/pages" -f "source[branch]=main" -f "source[path]=/" >> "$RESULT" 2>&1 \
  || echo "WARNING: aktifkan Pages manual di Settings → Pages" >> "$RESULT"

echo "[5/5] SELESAI ✅" >> "$RESULT"
echo "WEB_URL: https://$GH_USER.github.io/yors-market-analysis/" >> "$RESULT"
