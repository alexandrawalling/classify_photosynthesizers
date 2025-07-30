#!/bin/bash
#SBATCH --job-name=antismash_prodigal
#SBATCH --time=12:00:00
#SBATCH --partition=long-40core-shared
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G
#SBATCH --array=1-50
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=your@email.com

module load anaconda
conda activate antismash

CHUNK_FILE="$1"

INPUT_FILE=$(sed -n "$((SLURM_ARRAY_TASK_ID + 1))p" "$CHUNK_FILE" | cut -f2)
GENOME_DIR=$(dirname "$INPUT_FILE")
BASENAME=$(basename "$GENOME_DIR")


mkdir -p antismash_results/$BASENAME
antismash --output-dir antismash_results/$BASENAME --cpu 8 --genefinding-tool prodigal "$INPUT_FILE"

