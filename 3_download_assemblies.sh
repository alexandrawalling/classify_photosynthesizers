#!/bin/bash
#SBATCH --job-name=download_genomes    
#SBATCH --time=24:00:00              
#SBATCH --partition=long-96core-shared          
#SBATCH --nodes=1                    # Number of nodes
#SBATCH --ntasks=1                   # Number of tasks (1 for serial job)
#SBATCH --cpus-per-task=4            # Number of CPU cores per task
#SBATCH --mem=8G                     # Total memory per node (adjust as needed)
#SBATCH --mail-type=END,FAIL         # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=alexandra.walling@stonybrook.edu   # Your email address

module load anaconda

#conda init
conda activate ncbi_datasets

mkdir -p ncbi_genomes

while read -r taxid; do
    output_zip="ncbi_genomes_${taxid}.zip"

    if [[ -f "ncbi_genomes_jul_16/$output_zip" ]]; then
        echo "Skipping TaxID $taxid — already downloaded."
        continue
    fi

    echo "Downloading genomes for TaxID: $taxid"
    datasets download genome taxon "$taxid" --include protein --filename "$output_zip"
    sleep 1  # Be polite to NCBI
done < filtered_taxids.txt


