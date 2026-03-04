#!/bin/bash
#SBATCH --job-name=foldseek
#SBATCH --time=4:00:00
#SBATCH --partition=medium-40core
#SBATCH --cpus-per-task=25
#SBATCH --mem=128G


module load anaconda
conda activate ncbi_datasets


# Download reference FoldseekDB
#foldseek databases Alphafold/UniProt refFoldseekDB tmpFolder

# Convert to structure sequence DB
spacedust aa2foldseek targettestdir/targettestDB refFoldseekDB_dir/refFoldseekDB tmpFolder
spacedust aa2foldseek querytestdir/querytestDB refFoldseekDB_dir/refFoldseekDB tmpFolder
