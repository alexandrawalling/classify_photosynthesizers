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


find ncbi_genomes_jul_16/ncbi_genomes_*/ncbi_dataset/data \
  -type f -name protein.faa.gz |
awk -F/ '
  NR==FNR { acc[$1]; next }
  {
    for (a in acc)
      if ($0 ~ "/" a "/") { print; break }
  }
' candidate_genomes.txt -

