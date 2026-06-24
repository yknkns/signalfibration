#!/bin/sh
set -eu

NAME="cptac-pdac"
OUTDIR="./data/$NAME"
PROTEO="https://linkedomics.org/data_download/CPTAC-PDAC/proteomics_gene_level_MD_abundance_tumor.cct"
PHOSPHO="https://linkedomics.org/data_download/CPTAC-PDAC/phosphoproteomics_site_level_MD_abundance_tumor.cct"
CLINICAL="https://linkedomics.org/data_download/CPTAC-PDAC/clinical_table_140.tsv"

mkdir -p $OUTDIR
cd $OUTDIR
curl -O $PROTEO
curl -O $PHOSPHO
curl -O $CLINICAL
