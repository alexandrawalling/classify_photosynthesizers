#!/bin/bash
#SBATCH --job-name=foldseek
#SBATCH --time=24:00:00
#SBATCH --partition=long-40core-shared
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G


module load anaconda
conda activate ncbi_datasets


# Download reference FoldseekDB
foldseek databases Alphafold/UniProt refFoldseekDB tmpFolder

# Convert to structure sequence DB
spacedust aa2foldseek setDB refFoldseekDB tmpFolder
