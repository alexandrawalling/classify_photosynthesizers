#!/bin/bash
#SBATCH --job-name=build_signature     
#SBATCH --time=2:00:00   
#SBATCH --partition=long-40core-shared          
#SBATCH --nodes=1                    # Number of nodes
#SBATCH --ntasks=1                   # Number of tasks (1 for serial job)
#SBATCH --cpus-per-task=4            # Number of CPU cores per task
#SBATCH --mem=8G                     # Total memory per node (adjust as needed)

module load anaconda

conda activate smash


sourmash sketch dna -p scaled=1000,k=21 ../4_spacedust/query_genomes/cereibacter_sphaeroides/ncbi_dataset/data/GCF_003324715.1/GCF_003324715.1_ASM332471v1_genomic.fna -o csphaeroides.sig

mkdir target_genome_sigs

find ../4_spacedust/target_genomes/data -mindepth 1 -maxdepth 1 -type d | while read -r d; do
    fna=$(find "$d" -maxdepth 1 -name "*.fna" | head -n 1)

    if [[ -n "$fna" ]]; then
	    base=$(basename "$fna" .fna)
	    out="target_genome_sigs/${base}.sig"

	    sourmash sketch dna \
		    -p scaled=1000,k=21 \
		    "$fna" \
		    -o "$out"
     fi
done


