#!/bin/bash
#SBATCH --job-name=file_compressor       
#SBATCH --time=02:00:00              
#SBATCH --partition=long-96core-shared          
#SBATCH --nodes=1                    # Number of nodes
#SBATCH --ntasks=1                   # Number of tasks (1 for serial job)
#SBATCH --cpus-per-task=4            # Number of CPU cores per task
#SBATCH --mem=8G                     # Total memory per node (adjust as needed)
#SBATCH --mail-type=END,FAIL         # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=your@email.com   # Your email address


for dir in */; do
  # Remove trailing slash for cleaner output filename
  dirname="${dir%/}"
  echo "Archiving: $dirname -> ${dirname}.tar.zst"
  tar -cf "${dirname}.tar.zst" -I 'zstd -19 -T0' "$dir"
done
