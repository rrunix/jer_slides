#!/usr/bin/env bash
#
# Renderiza las diapositivas de Quarto y exporta cada deck a PDF/<nombre>.pdf.
#
# Usa decktape, que recorre el deck de reveal.js diapositiva a diapositiva en un
# Chromium headless (equivalente a abrir el deck con ?print-pdf y darle a imprimir,
# pero sin intervención manual).
#
# Uso:
#   ./render-pdf.sh                       # renderiza todo y exporta todos los decks
#   ./render-pdf.sh -n                    # sin renderizar, usa el HTML ya generado
#   ./render-pdf.sh ch4_rest.qmd          # solo algunos decks
#   ./render-pdf.sh -s 1920x1080          # otro tamaño de página
#
# Requisitos: quarto, decktape (npm install -g decktape), python3.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SLIDES_DIR="$ROOT/slides"
OUT_DIR="$ROOT/PDF"
SIZE="1280x720"
DO_RENDER=1
DECKS=()

while [ $# -gt 0 ]; do
    case "$1" in
        -n|--no-render) DO_RENDER=0 ;;
        -s|--size)      SIZE="${2:?falta el tamaño, p.ej. 1280x720}"; shift ;;
        -h|--help)      sed -n '3,15p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        -*)             echo "Opción desconocida: $1 (usa -h)" >&2; exit 2 ;;
        *)              DECKS[${#DECKS[@]}]="$1" ;;
    esac
    shift
done

for tool in quarto decktape python3; do
    command -v "$tool" >/dev/null 2>&1 || {
        echo "Falta '$tool' en el PATH." >&2
        [ "$tool" = decktape ] && echo "  Instálalo con: npm install -g decktape" >&2
        exit 1
    }
done

if [ "$DO_RENDER" -eq 1 ]; then
    echo "==> quarto render"
    quarto render "$ROOT"
    echo
fi

# Por defecto, todos los .qmd menos index.qmd (que es una página HTML, no un deck).
if [ ${#DECKS[@]} -eq 0 ]; then
    for qmd in "$ROOT"/*.qmd; do
        [ "$(basename "$qmd")" = "index.qmd" ] && continue
        DECKS[${#DECKS[@]}]="$qmd"
    done
fi

mkdir -p "$OUT_DIR"

# decktape necesita una URL: servimos slides/ en un puerto libre y lo cerramos al salir.
PORT="$(python3 -c 'import socket; s=socket.socket(); s.bind(("127.0.0.1", 0)); print(s.getsockname()[1]); s.close()')"
python3 -m http.server "$PORT" --bind 127.0.0.1 --directory "$SLIDES_DIR" >/dev/null 2>&1 &
SERVER_PID=$!
cleanup() { kill "$SERVER_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT INT TERM

for _ in $(seq 1 50); do
    curl -sfo /dev/null "http://127.0.0.1:$PORT/" && break
    sleep 0.2
done

LOG="$(mktemp -t decktape)"
failed=0
exported=0

for qmd in ${DECKS[@]+"${DECKS[@]}"}; do
    name="$(basename "$qmd" .qmd)"
    html="$SLIDES_DIR/$name.html"

    if [ ! -f "$html" ]; then
        echo "!! $name: falta $html (renderiza sin -n)" >&2
        failed=1
        continue
    fi

    printf '==> %-32s ' "$name.pdf"
    if decktape reveal "http://127.0.0.1:$PORT/$name.html" "$OUT_DIR/$name.pdf" \
            --size "$SIZE" >"$LOG" 2>&1; then
        printf '%s, %s\n' \
            "$(sed -n 's/^Printed \([0-9]*\) slides/\1 diapositivas/p' "$LOG" | tail -1)" \
            "$(du -h "$OUT_DIR/$name.pdf" | cut -f1 | tr -d ' ')"
        exported=$((exported + 1))
    else
        printf 'ERROR\n'
        sed 's/^/    /' "$LOG" >&2
        failed=1
    fi
done

rm -f "$LOG"

echo
echo "$exported PDF(s) en $OUT_DIR"
exit "$failed"
