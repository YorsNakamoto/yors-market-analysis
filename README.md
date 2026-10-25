# 📊 Yors Market Analysis v5 — XAU/USD

Alat analisa trading XAU/USD (Gold) satu-file HTML: real-time WebSocket, mesin scoring
konfluensi multi-timeframe, ICT/SMC, kalender ekonomi + news blackout, circuit breaker,
backtest replay + kalibrasi probabilitas, jurnal belajar adaptif, dan bot Telegram 2-arah.

**Buka `index.html`** — isi API key sendiri di halaman setup (semua data tersimpan lokal
di browser Anda, tidak dikirim ke server mana pun).

## Kebutuhan (semua opsional kecuali #1)
1. **TwelveData API key** (wajib) — gratis di [twelvedata.com](https://twelvedata.com) (800 req/hari)
2. **Telegram Bot** (opsional) — token + chat ID via @BotFather untuk sinyal & laporan
3. **Anthropic API key** (opsional) — untuk analisa fundamental AI & evaluasi performa
4. **FRED API key** (opsional) — [fred.stlouisfed.org](https://fred.stlouisfed.org/docs/api/api_key.html), untuk real yield TIPS

## Yang baru di v5
- 🔴 **FIX KALKULATOR LOT** — v4 salah 10× (memakai ×10, seharusnya ×100 → risiko 10% bukan 1%)
- ⏰ **Kill zone benar & DST-aware** — v4 melabel sesi bergeser satu sesi penuh
- 💧 **VWAP session-anchored** (reset 17:00 New York) — v4 rolling 24 jam
- 📅 **Kalender ekonomi + news blackout** — sinyal ditahan ±menit sebelum NFP/CPI/FOMC
- 🧠 **Bobot adaptif benar-benar dipakai** scoring (v4 hanya pajangan)
- 🏦 **COT z-score 2 tahun** (v4 threshold absolut → bias permanen LONG), DXY tren harian+5-hari (v4 noise 1 jam), **real yield 10Y TIPS** baru
- 🛑 **Circuit breaker** — pause otomatis setelah 4 SL / −4R per hari
- 💰 **Guard spread** — SL/TP tidak boleh lebih dekat dari batas spread
- 🧪 **Backtest replay walk-forward** + **kalibrasi probabilitas** (WR aktual per bucket skor) + statistik tersegmentasi (regime/grade/killzone/HTF)
- 🧹 Data fallback **ditandai jujur** (v4 menampilkan data palsu sebagai nyata), anti double-counting skor, ADX standar Wilder, divergensi RSI, TP struktural ke liquidity/S&R, satu mesin scoring terpadu (v4 punya dua yang bisa saling bertentangan)

## Deploy (GitHub Pages)
Folder ini siap deploy — `index.html` statis murni, tanpa build step.

## ⚠️ Disclaimer
Untuk edukasi dan referensi analisa. Bukan saran investasi. Trading gold/forex berisiko
tinggi kehilangan modal. Uji dulu di virtual/paper trade, dan selalu pakai manajemen risiko.
