#!/bin/sh

NAME="PXD058009"
OUTDIR="./data/$NAME"
URL="https://static-content.springer.com/esm/art%3A10.1038%2Fs44320-025-00141-1/MediaObjects/44320_2025_141_MOESM3_ESM.xlsx"

mkdir $OUTDIR
cd $OUTDIR
curl -O $URL
