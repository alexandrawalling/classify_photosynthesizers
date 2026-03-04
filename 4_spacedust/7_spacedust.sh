#!/bin/bash
#SBATCH --job-name=spacedust
#SBATCH --time=24:00:00
#SBATCH --time=4:00:00
#SBATCH --partition=medium-40core
#SBATCH --cpus-per-task=25
#SBATCH --mem=128G

module load anaconda
conda activate ncbi_datasets

# Search querySetDB against targetSetDB (using Foldseek and MMseqs)
spacedust clustersearch querytestdir/querytestDB targettestdir/targettestDB testresult.tsv tmpFolder --search-mode 1 --threads 1

