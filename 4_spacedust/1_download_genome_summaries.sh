#!/bin/bash
#SBATCH --job-name=genome_summaries       
#SBATCH --time=48:00:00              
#SBATCH --partition=extended-96core-shared          
#SBATCH --nodes=1                    # Number of nodes
#SBATCH --ntasks=1                   # Number of tasks (1 for serial job)
#SBATCH --cpus-per-task=4            # Number of CPU cores per task
#SBATCH --mem=8G                     # Total memory per node (adjust as needed)
#SBATCH --mail-type=END,FAIL         # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=your@email.com   # Your email address

module load anaconda

#conda init
conda activate ncbi_datasets


xargs -I {} datasets download genome accession {} \
  --include protein,gff3 \
  --dehydrated \
  --filename {}.zip \
  < test_genomes.txt


#datasets download genome accession GCF_000012905.2 --include protein,gff3 --dehydrated --filename feb_10_accessions.zip 

datasets rehydrate --directory ncbi_dataset
