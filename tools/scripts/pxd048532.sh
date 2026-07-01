#!/bin/sh
set -eu

NAME="pxd048532"
OUTDIR="./data/$NAME"
URL="https://www.science.org/doi/suppl/10.1126/science.adk0850/suppl_file/science.adk0850_data_s1_to_s8.zip"

mkdir -p $OUTDIR
cd $OUTDIR
wget -O ./data.zip $URL
unzip -o ./data.zip -d .
rm -rf ./data.zip
