#!/bin/bash
#SBATCH --job-name=hmmer
#SBATCH --time=24:00:00
#SBATCH --partition=long-96core-shared
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --array=0-18
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=alexandra.walling@stonybrook.edu


module load anaconda

source ~/.bashrc
conda activate ncbi_datasets


HMM=TIGR01115.hmm
CHUNK_FILE=$(printf "protein_faa_chunk_%04d" "${SLURM_ARRAY_TASK_ID}")

OUTDIR=hmmer_results
mkdir -p "${OUTDIR}"


while read -r FAA_GZ; do
    # Skip if file disappeared
    [[ ! -f "${FAA_GZ}" ]] && continue

    BASENAME=$(basename "$(dirname "${FAA_GZ}")")
    OUTFILE="${OUTDIR}/${BASENAME}.hmmsearch.out"

    hmmsearch \
        --cpu ${SLURM_CPUS_PER_TASK} \
	-E 1e-05 \
        "${HMM}" \
        "${FAA_GZ}" \
        >> "$OUTFILE"	

done < "${CHUNK_FILE}"

