#!/bin/bash
#SBATCH --job-name=genome_summaries       
#SBATCH --time=24:00:00              
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

> assembly_accessions.txt

while read -r acc <&3; do
    echo "Processing $acc..."
    esearch -db nucleotide -query "$acc" | \
    elink -target assembly -name nuccore_assembly | \
    efetch -format docsum | \
    xtract -pattern DocumentSummary -element AssemblyAccession >> assembly_accessions.txt
done 3< test_accessions.txt


datasets download genome accession --inputfile assembly_accessions.txt --include gbff --filename test_genomes.zip

unzip test_genomes.zip
