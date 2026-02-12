#!/bin/bash
#SBATCH --job-name=hmmer_pufm      
#SBATCH --time=48:00:00              
#SBATCH --partition=extended-96core-shared          
#SBATCH --nodes=1                    # Number of nodes
#SBATCH --ntasks=1                   # Number of tasks (1 for serial job)
#SBATCH --cpus-per-task=4            # Number of CPU cores per task
#SBATCH --mem=8G                     # Total memory per node (adjust as needed)
#SBATCH --mail-type=END,FAIL         # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=your@email.com   # Your email address

module load anaconda

conda init
conda activate ncbi_datasets

mkdir hmm_results

for file in ../2_antismash/ncbi_dataset/data/*gbff; do hmmsearch --cpu 4 TIGR01115.hmm $file > "hmmresults/$file.out"; done

