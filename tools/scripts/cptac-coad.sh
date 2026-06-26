#!/bin/sh
set -eu

NAME="cptac-coad"
OUTDIR="./data/$NAME"

PROTEO="https://linkedomics.org/cptac-colon/Human__CPTAC_COAD__PNNL__Proteome__TMT__03_01_2017__BCM__Gene__Tumor_Normal_log2FC.cct"
PHOSPHO="https://linkedomics.org/cptac-colon/Human__CPTAC_COAD__PNNL__Phosphoproteome__TMT__03_01_2017__BCM__Site__Tumor_Normal_log2FC.cct.gz"
CLINICAL="https://linkedomics.org/cptac-colon/Human__CPTAC_COAD__MS__Clinical__Clinical__03_01_2017__CPTAC__Clinical__BCM.tsi"

mkdir -p $OUTDIR
cd $OUTDIR

curl -O $PROTEO
curl -O $PHOSPHO
curl -O $CLINICAL
