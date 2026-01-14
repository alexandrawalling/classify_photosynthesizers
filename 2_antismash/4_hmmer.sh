#!/bin/bash
#SBATCH --job-name=hmmsearch_array
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --array=0-50   # will set dynamically below
#SBATCH --partition=long-40core-shared  


module load anaconda

source ~/.bashrc
conda activate ncbi_datasets

# Path to your directories list
DIR_LIST="antismash_results_dir_list.txt"
HMM_FILE="TIGR01115.hmm"

# Read directories into an array
mapfile -t DIRS < "$DIR_LIST"

# Update array range based on number of directories
if [ $SLURM_ARRAY_TASK_ID -ge ${#DIRS[@]} ]; then
    echo "Array index $SLURM_ARRAY_TASK_ID out of range"
    exit 1
fi

# Get the directory for this task
TARGET_DIR="${DIRS[$SLURM_ARRAY_TASK_ID]}"
FAA_FILE=$(find "$TARGET_DIR/cluster_fastas/" -maxdepth 1 -name "*.faa" | head -n 1)

if [ -z "$FAA_FILE" ]; then
    echo "No .faa file found in $TARGET_DIR"
    exit 1
fi

# Make output directory
OUT_DIR="$TARGET_DIR/hmm_results"
mkdir -p "$OUT_DIR"

# Run hmmsearch
hmmsearch --cpu 4 --tblout "$OUT_DIR/TIGR011115.tbl" "$HMM_FILE" "$FAA_FILE" > "$OUT_DIR/TIGR011115.out"

echo "Finished hmmsearch for $FAA_FILE"

