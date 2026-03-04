#!/bin/bash
#SBATCH --job-name=sourmash     
#SBATCH --time=2:00:00   
#SBATCH --partition=long-40core-shared          
#SBATCH --nodes=1                    # Number of nodes
#SBATCH --ntasks=1                   # Number of tasks (1 for serial job)
#SBATCH --cpus-per-task=4            # Number of CPU cores per task
#SBATCH --mem=8G                     # Total memory per node (adjust as needed)

module load anaconda

conda activate smash


sourmash index targetdb target_genome_sigs/*.sig

sourmash search csphaeroides.sig targetdb.sbt.zip -n 0 > sourmashsearch.txt

sourmash compare csphaeroides.sig target_genome_sigs/*sig --output sourmashcompare.txt

sourmash plot sourmashcompare.txt --subsample=100 --subsample-seed 7
