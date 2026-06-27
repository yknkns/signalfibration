#!/usr/bin/env bash
set -euo pipefail

DATASET="cptac-coad"
TAG="CPTAC_COAD"

RUN_DIR="./runs/${DATASET}/vespa.net"

PHOSPHO_RDS="$(realpath "./data/$DATASET/processed/${TAG}_phospho.rds")"
PROTEO_RDS="$(realpath "./data/$DATASET/processed/${TAG}_proteo.rds")"
FASTA="$(realpath "./tools/references/library.fasta")"

CONTAINER_PATH="$(realpath "../containers/datascience-notebook.sif")"
VENV_PATH="$(realpath "../.venv")"
VESPA_PKG_DIR="$(find "../renv/library" -name vespa -print -quit 2>/dev/null || true)"
RENV_LIB_DIR="$(realpath "$(dirname "${VESPA_PKG_DIR}")")"

mkdir -p ./runs/${DATASET}


module use /usr/local/package/modulefiles/
module load apptainer

if [[ ! -d "${RUN_DIR}/.git" ]]; then
  git clone https://github.com/califano-lab/vespa.net.git "${RUN_DIR}"
else
  echo "vespa.net already exists: ${RUN_DIR}"
fi

cd ${RUN_DIR}
RUN_DIR="$(pwd -P)"

ln -sf "${PHOSPHO_RDS}" "${TAG}_phospho.rds"
ln -sf "${PROTEO_RDS}" "${TAG}_proteo.rds"
ln -sf "${FASTA}" "library.fasta"
ln -sf "${TAG}_phospho.rds" "reference.rds"


apptainer exec \
  --env RUN_DIR="${RUN_DIR}" \
  --env VENV_PATH="${VENV_PATH}" \
  --env RENV_LIB_DIR="${RENV_LIB_DIR}" \
  "${CONTAINER_PATH}" \
  bash -c '
    set -euo pipefail

    export R_LIBS="${RENV_LIB_DIR}${R_LIBS:+:${R_LIBS}}"
    export R_LIBS_USER="${RENV_LIB_DIR}"

    cd "${RUN_DIR}"

    "${VENV_PATH}/bin/python" -m snakemake \
      --snakefile Snakefile \
      -j 64 \
      --restart-times 2
  '
