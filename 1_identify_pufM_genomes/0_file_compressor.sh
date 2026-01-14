#!/bin/bash
#SBATCH --job-name=file_compressor     
#SBATCH --time=24:00:00              
#SBATCH --partition=extended-96core-shared          
#SBATCH --nodes=1                    # Number of nodes
#SBATCH --ntasks=1                   # Number of tasks (1 for serial job)
#SBATCH --cpus-per-task=4            # Number of CPU cores per task
#SBATCH --mem=8G                     # Total memory per node (adjust as needed)
#SBATCH --mail-type=END,FAIL         # Mail events (NONE, BEGIN, END, FAIL, ALL)

find ncbi_genomes_jul_16 -type f -name '*.faa.tar.gz' -delete

find -name "*.faa" | xargs -I '{}' gzip {}
