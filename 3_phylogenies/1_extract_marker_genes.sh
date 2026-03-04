#!/bin/bash
#SBATCH --job-name=markergenes       
#SBATCH --time=1:00:00              
#SBATCH --partition=short-96core-shared          
#SBATCH --nodes=1                    # Number of nodes
#SBATCH --ntasks=1                   # Number of tasks (1 for serial job)
#SBATCH --cpus-per-task=1            # Number of CPU cores per task
#SBATCH --mem=8G                     # Total memory per node (adjust as needed)

module load anaconda

conda init
conda activate ncbi_datasets


python extract_marker_genes.py ../2_antismash/ncbi_dataset/data all_markers.fasta
