#!/bin/bash
#SBATCH --job-name=annotation
#SBATCH --time=4:00:00
#SBATCH --partition=short-96core-shared
#SBATCH --cpus-per-task=8
#SBATCH --mem=196G

module load anaconda
conda activate ncbi_datasets

mkdir -p test_output/functional_annotation
cat test_output/clusters/cluster*/cluster*.faa > test_output/functional_annotation/all_orfs.faa


mmseqs createdb test_output/functional_annotation/all_orfs.faa test_output/functional_annotation/orfs_db

#mmseqs databases UniRef90 uniref90 tmp

mmseqs search \
  /gpfs/projects/WeissmanGroup/awalling/4_spacedust/test_output/functional_annotation/orfs_db \
  /gpfs/projects/WeissmanGroup/awalling/4_spacedust/uniref90db/uniref90 \
  /gpfs/projects/WeissmanGroup/awalling/4_spacedust/test_output/functional_annotation/results \
  /gpfs/projects/WeissmanGroup/awalling/4_spacedust/test_output/functional_annotation/tmp \
  --threads 8


mmseqs convertalis test_output/functional_annotation/orfs_db uniref90db/uniref90 test_output/functional_annotation/results test_output/results.tsv
