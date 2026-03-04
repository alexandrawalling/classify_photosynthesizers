#!/bin/bash
#SBATCH --job-name=rename_files
#SBATCH --time=24:00:00
#SBATCH --partition=long-40core-shared
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G




awk '
BEGIN { FS=OFS="\t" }

# First pass: build accession -> species map
FNR==NR {
    acc = $1
    species = $2
    for (i=3; i<NF; i++) species = species " " $i   # rebuild species (ignore last column = taxid)
    acc2species[acc] = species
    next
}

# Second pass: process FASTA
/^>/ {
    header = substr($0,2)
    split(header, arr, "|")
    accession = arr[1]

    if (accession in acc2species) {
        newheader = ">" accession "|" acc2species[accession]
        for (i=2; i<=length(arr); i++)
            newheader = newheader "|" arr[i]
        print newheader
        next
    }
}

{ print }

' accession_species_map.tsv pufM_markers.fasta > pufM_species.fasta
