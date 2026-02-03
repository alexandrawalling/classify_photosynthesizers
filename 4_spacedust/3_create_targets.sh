#!/bin/bash
#SBATCH --job-name=spacedust_createDB
#SBATCH --time=2:00:00
#SBATCH --partition=short-40core-shared
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --array=1-10


TARGET_DIR = 
