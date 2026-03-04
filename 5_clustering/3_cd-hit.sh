#!/bin/bash
#SBATCH --job-name=cd-hit
#SBATCH --time=2:00:00
#SBATCH --partition=long-40core-shared
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G

module load anaconda

#conda init
conda activate ncbi_datasets


cd-hit -i pufM_species.fasta -o pufMout.fasta -c 0.75 -n 5 -d 0 -M 16000 -T 8
