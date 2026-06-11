#!/usr/bin/env bash
set -euo pipefail

DATASET="cptac-luad"
TAG="CPTAC_LUAD"

RUN_DIR="./runs/${DATASET}/vespa.net"

PHOSPHO_RDS="$(realpath "./data/$DATASET/processed/${TAG}_phospho.rds")"
PROTEO_RDS="$(realpath "./data/$DATASET/processed/${TAG}_proteo.rds")"
FASTA="$(realpath "./tools/references/library.fasta")"

CONTAINER_PATH="$(realpath "../containers/datascience-notebook.sif")"
VENV_PATH="$(realpath "../.venv")"

mkdir -p ./runs/${DATASET}

[[ -f "${PHOSPHO_RDS}" ]] || { echo "Missing: ${PHOSPHO_RDS}"; exit 1; }
[[ -f "${PROTEO_RDS}" ]] || { echo "Missing: ${PROTEO_RDS}"; exit 1; }
[[ -f "${FASTA}" ]] || { echo "Missing: ${FASTA}"; exit 1; }

module use /usr/local/package/modulefiles/
module load singularity apptainer

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

HOST_APPTAINER="$(readlink -f "$(command -v singularity)")"
APPTAINER_PREFIX="$(cd "$(dirname "${HOST_APPTAINER}")/.." && pwd -P)"

MKSQUASHFS_DIR="$(dirname "$(command -v mksquashfs)")"
LZO_REAL=$(readlink -f "$(ldd "$(command -v mksquashfs)" | awk '/liblzo2\.so\.2/ {print $3}')")

SQUASHFUSE_LL="/usr/local/package/apptainer/1.2.4/squashfuse/bin/squashfuse_ll"
FUSE_REAL="$(readlink -f "$(ldd "$SQUASHFUSE_LL" | awk '/libfuse\.so\.2/ {print $3}')")"

WRAP_DIR="${RUN_DIR}/.host_apptainer_wrappers"
HOST_LIB_DIR="${RUN_DIR}/.host_libs"
mkdir -p "${WRAP_DIR}" "${HOST_LIB_DIR}"

cp -L "${FUSE_REAL}" "${HOST_LIB_DIR}/libfuse.so.2"

cat > "${WRAP_DIR}/squashfuse_ll" <<'EOF'
#!/bin/sh
set -eu

export LD_LIBRARY_PATH="/opt/host-libs:/lib64:/usr/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"

exec /opt/host-apptainer-bin/squashfuse_ll.real "$@"
EOF

chmod +x "${WRAP_DIR}/squashfuse_ll"


apptainer exec \
  --bind "${APPTAINER_PREFIX}:${APPTAINER_PREFIX}" \
  --bind "${MKSQUASHFS_DIR}:${MKSQUASHFS_DIR}" \
  --bind "${LZO_REAL}:/lib64/liblzo2.so.2:ro" \
  --bind "${HOST_LIB_DIR}:/opt/host-libs:ro" \
  --bind "${SQUASHFUSE_LL}:/opt/host-apptainer-bin/squashfuse_ll.real:ro" \
  --bind "${WRAP_DIR}/squashfuse_ll:${SQUASHFUSE_LL}:ro" \
  --env RUN_DIR="${RUN_DIR}" \
  --env APPTAINER_PREFIX="${APPTAINER_PREFIX}" \
  --env MKSQUASHFS_DIR="${MKSQUASHFS_DIR}" \
  --env LD_LIBRARY_PATH="/opt/host-libs:/lib64:/usr/lib64" \
  --env VENV_PATH="${VENV_PATH}" \
  "${CONTAINER_PATH}" \
  bash -c '
    set -euo pipefail

    export PATH="${APPTAINER_PREFIX}/bin:${PATH}"
    export LD_LIBRARY_PATH="/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"

    export SINGULARITYENV_LD_LIBRARY_PATH="/lib64"
    export APPTAINERENV_LD_LIBRARY_PATH="/lib64"
    
    export PATH="/usr/local/package/apptainer/1.2.4/squashfuse/bin:${PATH}"
    export LD_LIBRARY_PATH="/lib64:/usr/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"

    INNER_R_LIBS_SITE="/usr/local/lib/R/site-library:/usr/lib/R/site-library:/usr/lib/R/library"

    export APPTAINERENV_R_LIBS_SITE="${INNER_R_LIBS_SITE}"
    export SINGULARITYENV_R_LIBS_SITE="${INNER_R_LIBS_SITE}"

    cd "${RUN_DIR}"

    "${VENV_PATH}/bin/python" -m snakemake \
      --snakefile Snakefile \
      --use-singularity \
      --singularity-args="--userns --env R_LIBS_SITE=${INNER_R_LIBS_SITE}" \
      -j 64 \
      --restart-times 2
  '
