#!/bin/sh
set -eu

NAME="cptac-luad"
OUTDIR="./data/$NAME"
TASK="c93a1b9a3fc44f13bc071171888c4073"
BASE="https://massive.ucsd.edu/ProteoSAFe/DownloadResultFile"

mkdir -p "$OUTDIR"
cd "$OUTDIR"

curl -o CPTAC3_Lung_Adeno_Carcinoma_Proteome.tmt10.tsv "$BASE?task=$TASK&block=main&file=f.MSV000086793/quant/quant/CPTAC3_Lung_Adeno_Carcinoma_Proteome.tmt10.tsv"

curl -o CPTAC3_Lung_Adeno_Carcinoma_Phosphoproteome.phosphopeptide.tmt10.tsv "$BASE?task=$TASK&block=main&file=f.MSV000086793/quant/quant/CPTAC3_Lung_Adeno_Carcinoma_Phosphoproteome.phosphopeptide.tmt10.tsv"

curl -o S046_Lung_Adenocarcinoma.csv "$BASE?task=$TASK&block=main&file=f.MSV000086793/quant_stats/S046_Lung_Adenocarcinoma.csv"
