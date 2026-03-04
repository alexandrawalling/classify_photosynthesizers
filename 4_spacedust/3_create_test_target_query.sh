#!/bin/bash
#SBATCH --job-name=spacedust_createDB
#SBATCH --time=2:00:00
#SBATCH --partition=short-40core-shared
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G


module load anaconda
conda activate ncbi_datasets




spacedust createsetdb target_genomes/data/GCF_000012905.2/GCF_000012905.2.faa  querytestDB tmpFolder --gff-dir query_gff.txt --gff-type CDS

spacedust createsetdb target_genomes/data/GCF_000013085.1/GCF_000013085.1.faa targettestDB tmpFolder --gff-dir target_gff.txt --gff-type CDS
