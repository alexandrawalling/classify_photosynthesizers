#!/bin/bash
#SBATCH --job-name=hmmer
#SBATCH --time=24:00:00
#SBATCH --partition=long-96core-shared
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=alexandra.walling@stonybrook.edu


module load anaconda

source ~/.bashrc
conda activate ncbi_datasets


for file in antismash_results/G*/cluster_genbanks/*gbk; do echo $file >> summary_jan_13.txt; grep -e "chlorophyllide" -e "photosynthesis" -e "magnesium" $file >> summary_jan_13.txt; done

