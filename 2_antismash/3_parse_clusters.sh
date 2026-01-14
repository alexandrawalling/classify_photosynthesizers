#!/bin/bash
#SBATCH --job-name=antismash       
#SBATCH --time=12:00:00              
#SBATCH --partition=long-40core-shared          
#SBATCH --cpus-per-task=8            # Number of CPU cores per task
#SBATCH --mem=8G                    # Total memory per node (adjust as needed)
#SBATCH --mail-type=END,FAIL         # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=your@email.com   # Your email address

module load anaconda

#conda init
conda activate ncbi_datasets

ls -d antismash_results/GC* > antismash_results_dir_list.txt

while read -r dir; do
	echo "Parsing $dir"
	python new_new_parser.py "$dir"
done < antismash_results_dir_list.txt

while read -r dir; do
	echo "Processing clusters from $dir"
	python new_extract_cluster_genbank.py "$dir" "$dir/cluster_membership.tsv"
done < antismash_results_dir_list.txt
