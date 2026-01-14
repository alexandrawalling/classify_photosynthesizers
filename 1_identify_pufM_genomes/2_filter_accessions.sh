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

#Extract list of taxon ids from assembly data report
jq -r '.organism.tax_id' assembly_data_report.jsonl > taxid_list_unfiltered.txt


#Install NCBI taxonomy dump
#wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/new_taxdump/new_taxdump.tar.gz
#tar -zxvf new_taxdump.tar.gz

#conda install -c bioconda taxonkit


#Filter taxon ids

# Input files
UNFILTERED="taxid_list_unfiltered.txt"
EXCLUDE_GENUS="working_excluded_taxids.txt"
TAXDUMP_DIR="/gpfs/projects/WeissmanGroup/awalling/new_taxdump/"

# Output files
FULL_LINEAGE="full_lineage.txt"
LINEAGE_WITH_TAXIDS="taxid_with_lineage_ids.txt"
TAXID_TO_GENUS="taxid_to_genus_taxid.txt"
FILTERED="filtered_taxids.txt"


echo "Step 1 + 2: Get full lineage and lineage taxids..."
taxonkit lineage "$UNFILTERED" --show-lineage-taxids --data-dir "$TAXDUMP_DIR" > "$LINEAGE_WITH_TAXIDS"


echo "Step 3: Extract genus taxids from lineage..."
cut -f3 "$LINEAGE_WITH_TAXIDS" \
    | awk -F'\t' '{split($1,a,";"); print a[length(a)]}' \
    | grep -v -F -f "$EXCLUDE_GENUS" \
    | sort -u > "$FILTERED"



echo "Filtering complete! Filtered taxids saved to $FILTERED"

