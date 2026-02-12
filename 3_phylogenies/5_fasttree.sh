#!/bin/bash
#SBATCH --job-name=fasttree
#SBATCH --time=48:00:00
#SBATCH --partition=extended-96core-shared
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=7
#SBATCH --mem=8G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=your@email.com

module load anaconda

# Activate conda properly in a non-interactive shell
source ~/.bashrc
conda activate ncbi_datasets

FastTree U1.raxml.reduced.phy > pufM_fasttree.tree
