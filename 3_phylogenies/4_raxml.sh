#!/bin/bash
#SBATCH --job-name=raxml
#SBATCH --time=48:00:00
#SBATCH --partition=extended-96core-shared
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=7
#SBATCH --mem=8G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=your@email.com

module load anaconda

# Activate conda properly in a non-interactive shell
source ~/.bashrc
conda activate ncbi_datasets

raxml-ng --check --msa 16S_alignment_mafft_feb_10.fasta --model GTR+G --prefix T1

#raxml-ng --check --msa pufM_alignment_mafft_feb9.fasta --model LG --prefix U1


raxml-ng --parse --msa T1.raxml.reduced.phy --model GTR+G --prefix T2

#raxml-ng --parse --msa U1.raxml.reduced.phy --model LG --prefix U2


#raxml-ng --all --msa T2.raxml.rba --model GTR+G --prefix T15 --seed 2 --threads 7 --bs-metric fbp --bs-trees 50

#raxml-ng --all --msa U2.raxml.rba --model LG --prefix U15 --seed 2 --threads 3 --bs-metric fbp --bs-trees 10
