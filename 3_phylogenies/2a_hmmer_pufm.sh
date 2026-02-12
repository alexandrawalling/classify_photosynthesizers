#!/bin/bash
#SBATCH --job-name=hmmer_pufm
#SBATCH --time=48:00:00
#SBATCH --partition=extended-96core-shared
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=your@email.com

module load anaconda

# Activate conda properly in a non-interactive shell
source ~/.bashrc
conda activate ncbi_datasets

# Create output directory (match name used below)
mkdir -p hmm_results

HMM_FILE="TIGR01115.hmm"
INPUT_DIR="../2_antismash/ncbi_dataset/data"

for file in "${INPUT_DIR}"/*.faa; do
    base=$(basename "$file" .faa)
    hmmsearch --cpu "${SLURM_CPUS_PER_TASK}" \
        "$HMM_FILE" \
        "$file" \
        > "hmm_results/${base}.out"
done

