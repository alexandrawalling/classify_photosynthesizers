#!/bin/bash
#SBATCH --job-name=createSetDB_array
#SBATCH --time=24:00:00
#SBATCH --partition=long-40core-shared
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --array=1-1        # overridden at submission



find target_genomes/data -mindepth 1 -maxdepth 1 -type d | while read -r d; do
    fna=$(find "$d" -maxdepth 1 -name "*.fna" | head -n 1)
    gff=$(find "$d" -maxdepth 1 -name "*.gff" | head -n 1)

    [[ -f "$fna" && -f "$gff" ]] || continue

    mv "$fna" "$d/genomic.fna"
    mv "$gff" "$d/genomic.gff"
done

