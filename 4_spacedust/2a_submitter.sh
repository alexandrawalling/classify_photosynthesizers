#!/bin/bash
#SBATCH --job-name=spacedust_createDB
#SBATCH --time=2:00:00
#SBATCH --partition=short-40core-shared

# submit_stepA_batches.sh
# Submits Step A in safe array batches with concurrency limit

TOTAL_GENOMES=2916
BATCH_SIZE=50
CONCURRENT=25

START=1
while [[ $START -le $TOTAL_GENOMES ]]; do
    END=$(( START + BATCH_SIZE - 1 ))
    if [[ $END -gt $TOTAL_GENOMES ]]; then
        END=$TOTAL_GENOMES
    fi

    echo "Submitting Step A array: $START-$END%$CONCURRENT"
    sbatch --array=${START}-${END}%${CONCURRENT} 2_create_inividual_targetdbs.sh

    START=$(( END + 1 ))
done

