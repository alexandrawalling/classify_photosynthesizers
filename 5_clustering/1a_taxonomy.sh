#!/bin/bash
#SBATCH --job-name=genome_names      
#SBATCH --time=48:00:00              
#SBATCH --partition=extended-96core-shared          
#SBATCH --nodes=1                    # Number of nodes
#SBATCH --ntasks=1                   # Number of tasks (1 for serial job)
#SBATCH --cpus-per-task=4            # Number of CPU cores per task
#SBATCH --mem=8G                     # Total memory per node (adjust as needed)

module load anaconda

#conda init
conda activate ncbi_datasets

datasets summary genome accession \
	--inputfile accessions.txt \
	--as-json-lines > assembly_metadata.jsonl



jq -r '
  .accession + "\t" +
  .organism.organism_name + "\t" +
  (.organism.tax_id | tostring)
' assembly_metadata.jsonl > accession_species_map.tsv
