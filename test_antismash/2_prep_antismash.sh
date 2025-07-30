#!/bin/bash
#SBATCH --job-name=antismash_prep
#SBATCH --time=1:00:00              
#SBATCH --partition=short-40core-shared          
#SBATCH --cpus-per-task=1            # Number of CPU cores per task
#SBATCH --mem=4G                     # Total memory per node (adjust as needed)
#SBATCH --mail-type=END,FAIL         # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=your@email.com   # Your email address

module load anaconda

#conda init
conda activate antismash

#antismash ncbi_dataset/data/GCF_000425365.1/genomic.gbff

find ncbi_dataset/data -maxdepth 1 -mindepth 1 -type d -name 'GC*' -exec test -f {}/genomic.gbff \; -print > genome_dirs.txt


#split -l 50 genome_dirs.txt genome_chunk_


mkdir gbff_classified

python check_gbff_annotations.py genome_dirs.txt 

mv normal.tsv prodigal.tsv gbff_classified/

split -l 50 gbff_classified/normal.tsv chunk_with_cds_
split -l 50 gbff_classified/prodigal.tsv chunk_needs_prodigal_


