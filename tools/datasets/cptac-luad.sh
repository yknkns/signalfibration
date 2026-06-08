#!/bin/sh

NAME="cptac-luad"
OUTDIR="./data/$NAME"
PROTEOME_URL="https://linkedomics.org/data_download/CPTAC-LUAD/HS_CPTAC_LUAD_proteome_ratio_NArm_TUMOR.cct"
PHOSPHO_URL="https://linkedomics.org/data_download/CPTAC-LUAD/HS_CPTAC_LUAD_phosphoproteome_ratio_norm_NArm_TUMOR.cct"
CLINICAL_URL="https://linkedomics.org/data_download/CPTAC-LUAD/HS_CPTAC_LUAD_cli.tsi"

mkdir $OUTDIR
cd $OUTDIR
curl -O $PROTEOME_URL
curl -O $PHOSPHO_URL
curl -O $CLINICAL_URL
