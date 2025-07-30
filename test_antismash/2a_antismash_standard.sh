#!/bin/bash
#SBATCH --job-name=antismash       
#SBATCH --time=12:00:00              
#SBATCH --partition=long-40core-shared          
#SBATCH --cpus-per-task=8            # Number of CPU cores per task
#SBATCH --mem=16G                    # Total memory per node (adjust as needed)
#SBATCH --array=1-50
#SBATCH --mail-type=END,FAIL         # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=your@email.com   # Your email address

module load anaconda

#conda init
conda activate antismash



CHUNK_FILE="$1"

INPUT_FILE=$(sed -n "$((SLURM_ARRAY_TASK_ID + 1))p" "$CHUNK_FILE" | cut -f2)
GENOME_DIR=$(dirname "$INPUT_FILE")
BASENAME=$(basename "$GENOME_DIR")

echo $GENOME_DIR
echo $INPUT_FILE
echo $BASENAME

mkdir -p antismash_results/${BASENAME}

antismash --debug --verbose --output-dir antismash_results/${BASENAME} --cpu 8 "$INPUT_FILE"


