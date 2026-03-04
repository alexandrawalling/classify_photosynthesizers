#!/bin/bash
#SBATCH --job-name=prodigal       
#SBATCH --time=24:00:00              
#SBATCH --partition=long-40core-shared          
#SBATCH --nodes=1                    # Number of nodes
#SBATCH --ntasks=1                   # Number of tasks (1 for serial job)
#SBATCH --cpus-per-task=4            # Number of CPU cores per task
#SBATCH --mem=8G                     # Total memory per node (adjust as needed)

module load anaconda

#conda init
conda activate ncbi_datasets



TARGET_DIR=target_genomes/data/

for fna in target_genomes/data/GCF*/genomic.fna; do
	outdir=$(dirname "$fna")
	prefix=$(basename "$outdir")
	prodigal \
		-i "$fna" \
		-o "${outdir}/${prefix}.gff3" \
		-f gff \
		-a "${outdir}/${prefix}.faa" \
		-d "${outdir}/${prefix}.fna" \
		-p single
	done



