#!/bin/bash
#SBATCH --job-name=prodigalclusters
#SBATCH --time=4:00:00
#SBATCH --partition=short-96core-shared
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G

module load anaconda
conda activate ncbi_datasets

for d in test_output/clusters/cluster*; do
    f="$d/$(basename $d).fasta"   # e.g., clusters/cluster1/cluster1.fasta
    cname=$(basename "$d")
    
    prodigal \
        -i "$f" \
        -a "$d/${cname}.faa" \
        -d "$d/${cname}.fna" \
        -f gff \
        -o "$d/${cname}.gff" \
        -p meta
done


