#!/bin/bash
#SBATCH --job-name=clusterparsing
#SBATCH --time=24:00:00
#SBATCH --time=4:00:00
#SBATCH --partition=short-96core-shared
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G

module load anaconda
conda activate ncbi_datasets

#Convert spacedust results into bed file for bedtools
python spacedust_to_bed.py test_output/testresult.tsv test_output/output.bed


#get fasta sequences for each cluster from NCBI genomic.fna based on coordinates in bed file
bedtools getfasta -fi test_output/genomic.fna -bed test_output/output.bed -fo test_output/clusters.fa -name

#Extract each cluster into separate directories
awk '/^>/{split($0,a,"::"); cname=a[1]; sub(/^>/,"",cname); dir="test_output/clusters/"cname; system("mkdir -p "dir); out=dir"/"cname".fasta"} {print >> out}' test_output/clusters.fa
