#!/bin/bash
#SBATCH --job-name=hmmer_prep    
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

cd ncbi_genomes_jul_16

# Find and unzip each .zip file
find . -type f -name "*.zip" | while read -r zipfile; do
    # Get the base name without extension, e.g. "ncbi_genomes_123456" from "ncbi_genomes_123456.zip"
    base=$(basename "$zipfile" .zip)
    
    # Create a directory named after the zip file (without .zip)
    target_dir="${base}"
    mkdir -p "$target_dir"

    echo "Unzipping $zipfile into $target_dir"

    # Unzip into the new directory (avoid creating ncbi_dataset/data)
    unzip -q "$zipfile" -d "$target_dir"

    # Optionally flatten the directory if needed
    # mv "$target_dir"/ncbi_dataset/data/* "$target_dir"/
    # rm -rf "$target_dir"/ncbi_dataset
done

echo "All archives unzipped."


