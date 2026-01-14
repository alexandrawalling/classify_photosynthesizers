#!/bin/bash
#SBATCH --job-name=hmmer
#SBATCH --time=2:00:00
#SBATCH --partition=short-40core-shared 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=alexandra.walling@stonybrook.edu


module load anaconda

source ~/.bashrc
conda activate ncbi_datasets


for file in hmmer_results/*hmmsearch.out; do grep -l alifrom $file >> summary.txt; done

