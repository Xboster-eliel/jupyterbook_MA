#!/usr/bin/env bash
set -euo pipefail

BOOK_DIR="/home/gentek-g3-esp/jupyterbook/Temas/series_tiempo"
VENV_BIN="${BOOK_DIR}/.venv/bin"

cd "${BOOK_DIR}"
"${VENV_BIN}/jupyter-book" start "$@"
