#!/bin/bash
#SBATCH --job-name=hmmer_pufm
#SBATCH --time=1:00:00
#SBATCH --partition=long-96core-shared
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G

module load anaconda

# Activate conda properly in a non-interactive shell
source ~/.bashrc
conda activate ncbi_datasets

# Create output directory (match name used below)
mkdir -p test_output/hmm_results

HMM_FILE="TIGR01115.hmm"

hmmsearch --cpu 4 $HMM_FILE test_output/functional_annotation/all_orfs.faa > test_output/hmm_results/hmm_results.txt
