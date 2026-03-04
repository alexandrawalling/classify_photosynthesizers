#!/bin/bash
#SBATCH --job-name=hmmer_pufm
#SBATCH --time=1:00:00
#SBATCH --partition=short-96core-shared
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G

module load anaconda

# Activate conda properly in a non-interactive shell
source ~/.bashrc
conda activate ncbi_datasets

DEST_DIR="../hmmer_hits_faa"
mkdir -p "$DEST_DIR"

for out in hmm_results/*.out; do
    # Only keep outputs with hits
    if grep -q -v "^#" "$out" && grep -qE "\S" "$out"; then
        base=$(basename "$out" .out)
        faa_file=$(find ../4_spacedust/target_genomes/data -type f -name "${base}.faa")
        if [ -f "$faa_file" ]; then
            echo "Copying $faa_file -> $DEST_DIR/"
            cp "$faa_file" "$DEST_DIR/"
        else
            echo "Warning: Could not find .faa for $base"
        fi
    fi
done
