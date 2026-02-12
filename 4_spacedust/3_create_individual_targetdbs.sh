#!/bin/bash
#SBATCH --job-name=spacedust_createDB
#SBATCH --time=2:00:00
#SBATCH --partition=short-40core-shared
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --array=1-2916
#SBATCH --output=logs/createDB_%A_%a.out
#SBATCH --error=logs/createDB_%A_%a.err

set -euo pipefail

module load anaconda
conda activate ncbi_datasets

INPUT_ROOT="target_genomes/data"
PER_GENOME_DB_ROOT="per_genome_db"
TMP_ROOT="${SLURM_TMPDIR:-tmpDBs}"

mkdir -p logs "${PER_GENOME_DB_ROOT}" "${TMP_ROOT}"

# List all genome directories
mapfile -t GENOME_DIRS < <(find "${INPUT_ROOT}" -mindepth 1 -maxdepth 1 -type d | sort)
TOTAL=${#GENOME_DIRS[@]}

TASK_ID=${SLURM_ARRAY_TASK_ID}
INDEX=$((TASK_ID - 1))

if [[ ${INDEX} -ge ${TOTAL} ]]; then
    echo "No genome assigned for task ${TASK_ID}"
    exit 0
fi

GENOME_DIR="${GENOME_DIRS[INDEX]}"
GENOME_NAME=$(basename "${GENOME_DIR}")
OUT_DB="${PER_GENOME_DB_ROOT}/${GENOME_NAME}_db"
TMP_DIR="${TMP_ROOT}/${GENOME_NAME}"

mkdir -p "${TMP_DIR}"

# Skip if already exists
if [[ -d "${OUT_DB}" ]]; then
    echo "DB for ${GENOME_NAME} already exists, skipping"
    exit 0
fi

FNA="${GENOME_DIR}/genomic.fna"
GFF="${GENOME_DIR}/genomic.gff"

if [[ ! -f "${FNA}" || ! -f "${GFF}" ]]; then
    echo "Missing files in ${GENOME_DIR}, skipping"
    exit 1
fi

export MMSEQS_NUM_THREADS=2

spacedust createsetdb \
    "${FNA}" \
    "${OUT_DB}" \
    "${TMP_DIR}" \
    --gff-dir "${GFF}" \
    --gff-type CDS

echo "Created per-genome DB: ${OUT_DB}"

