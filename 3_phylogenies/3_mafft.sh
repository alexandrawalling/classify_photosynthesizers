#!/bin/bash
#SBATCH --job-name=mafft
#SBATCH --time=48:00:00
#SBATCH --partition=extended-96core-shared
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=your@email.com

module load anaconda

# Activate conda properly in a non-interactive shell
source ~/.bashrc
conda activate ncbi_datasets


module load mafft/7.490   

mafft 16S_markers_headers.fasta > 16S_alignment_mafft_feb_10.fasta 


#mafft pufM_markers_headers.fasta > pufM_alignment_mafft_feb9.fasta 
