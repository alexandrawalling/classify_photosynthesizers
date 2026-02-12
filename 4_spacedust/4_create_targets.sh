#!/bin/bash
#SBATCH --job-name=createtargetdb
#SBATCH --time=24:00:00
#SBATCH --partition=long-40core
#SBATCH --cpus-per-task=20
#SBATCH --mem=128G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=alexandra.walling@stonybrook.edu

module load anaconda

conda activate ncbi_datasets

INPUT_ROOT="target_genomes/data"

mapfile -t FNA_FILES < <(find "$INPUT_ROOT" -type f -name "*.fna")

echo "$FNA_FILES"

find target_genomes/data -name "genomic.gff" | sort > gff_files.txt

if [[${#FNA_FILES[@]} -eq 0 ]]; then
	echo "ERROR: no fna files found"
	exit 1
fi

echo "FOUND ${#FNA_FILES[@]} genomes"

spacedust createsetdb "${FNA_FILES[@]}" targetDB tmpFolder --gff-dir gff_files.txt --gff-type CDS
