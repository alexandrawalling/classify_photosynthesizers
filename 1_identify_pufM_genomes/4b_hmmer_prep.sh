#!/bin/bash
#SBATCH --job-name=hmmer_prep    
#SBATCH --time=24:00:00              
#SBATCH --partition=long-96core-shared          
#SBATCH --nodes=1                    # Number of nodes
#SBATCH --ntasks=1                   # Number of tasks (1 for serial job)
#SBATCH --cpus-per-task=4            # Number of CPU cores per task
#SBATCH --mem=8G                     # Total memory per node (adjust as needed)
#SBATCH --mail-type=END,FAIL         # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=alexandra.walling@stonybrook.edu   # Your email address

module load anaconda

conda init
conda activate ncbi_datasets


find ncbi_genomes_jul_16 \
	-type f \
	-path '*/ncbi_dataset/data/GCF*/protein.faa.gz' \
	> protein_faa_files.txt

wc -l protein_faa_files.txt

split -l 10000 -d -a 4 protein_faa_files.txt protein_faa_chunk_

#hmmsearch TIGR01115.hmm ncbi_genomes_jul_16/ncbi_genomes_90060/ncbi_dataset/data/GCF_012911005.2/protein.faa.gz > test_hmm.out

