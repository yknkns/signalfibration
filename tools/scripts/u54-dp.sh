#!/bin/sh
set -eu

NAME="u54-dp"
OUTDIR="./data/$NAME"
URL="https://static-content.springer.com/esm/art%3A10.1038%2Fs41467-024-47957-3/MediaObjects/41467_2024_47957_MOESM11_ESM.zip"

mkdir -p $OUTDIR
cd $OUTDIR
curl -o ./data.zip $URL
unzip -o ./data.zip -d .
rm -rf ./data.zip
