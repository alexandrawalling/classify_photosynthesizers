#!/bin/bash
#SBATCH --job-name=extract_taxids    
#SBATCH --time=2:00:00              
#SBATCH --partition=short-40core-shared          
#SBATCH --nodes=1                    # Number of nodes
#SBATCH --ntasks=1                   # Number of tasks (1 for serial job)
#SBATCH --cpus-per-task=4            # Number of CPU cores per task
#SBATCH --mem=8G                     # Total memory per node (adjust as needed)
#SBATCH --mail-type=END,FAIL         # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=alexandra.walling@stonybrook.edu   # Your email address

module load anaconda

#conda init
conda activate ncbi_datasets

jq -r '.organism.tax_id' assembly_data_report.jsonl > taxid_list_unfiltered.txt


#Install NCBI taxonomy dump
#wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/new_taxdump/new_taxdump.tar.gz
#tar -zxvf new_taxdump.tar.gz

#conda install -c bioconda taxonkit

# Get genus names for each taxid
taxonkit lineage taxid_list_unfiltered.txt -d -t -R --data-dir ./new_taxdump \
    | taxonkit reformat -f '{genus}' \
    | awk -F'\t' '{print $1"\t"$2}' > taxid_to_genus.txt

# Filter out taxids whose genus is in the exclusion list
grep -v -F -f working_excluded_taxon_names.txt taxid_to_genus.txt \
    | cut -f1 > filtered_taxids.txt

