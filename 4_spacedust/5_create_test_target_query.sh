#!/bin/bash
#SBATCH --job-name=spacedust_createDB
#SBATCH --time=2:00:00
#SBATCH --partition=short-40core-shared
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G

#find feb_10_accessions/ncbi_dataset/data -name "genomic.gff" | sort > gff_files.txt
#spacedust createsetdb feb_10_accessions/ncbi_dataset/data/GCF_000015985.1/genomic.faa targettestDB tmpFolder --gff-dir gff_files.txt --gff-type CDS

find test_genomes/ncbi_dataset/data -name "genomic.gff" | sort > query_gff.txt

spacedust createsetdb test_genomes/ncbi_dataset/data/GCF_000012905.2/genomic.faa  querytestDB tmpFolder --gff-dir query_gff.txt --gff-type CDS
