#!/bin/sh
set -eu

NAME="pxd050707"
OUTDIR="./data/$NAME"
URL="https://zenodo.org/records/10792252/files/Github_input.zip?download=1"

mkdir -p $OUTDIR
cd $OUTDIR
curl -o ./data.zip $URL
unzip -o ./data.zip -d $OUTDIR
rm -rf ./data.zip
