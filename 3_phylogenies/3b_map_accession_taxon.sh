#!/bin/bash
#SBATCH --job-name=accessions_map
#SBATCH --time=4:00:00
#SBATCH --partition=long-96core-shared
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G

module load anaconda

# Activate conda properly in a non-interactive shell
source ~/.bashrc
conda activate ncbi_datasets



#datasets summary genome accession --inputfile accessions_pufM.txt --as-json-lines > protein_summary.json

epost -db protein -input accessions_pufM.txt |
esummary |
xtract -pattern DocumentSummary \
  -element AccessionVersion Organism \
> accession_to_taxon.tsv



