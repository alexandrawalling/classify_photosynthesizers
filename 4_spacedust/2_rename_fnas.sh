#!/bin/bash
#SBATCH --job-name=rename_files
#SBATCH --time=24:00:00
#SBATCH --partition=long-40core-shared
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G



awk -F '\t' '{
  species=$2
  gsub(/[^A-Za-z0-9 ]/, "", species)
  gsub(/ /, "_", species)
  species=tolower(species)
  print $1 "\t" species
}' accession_species_map.tsv > accession_species_clean.tsv

cd target_genomes/data
while IFS=$'\t' read -r acc species; do

  dir="$acc"

  if [[ -d "$dir" ]]; then
    for file in "$dir"/*; do
      if [[ -f "$file" ]]; then
        ext="${file##*.}"
        newname="${dir}/${acc}_${species}.${ext}"

        # Prevent overwriting
        if [[ ! -e "$newname" ]]; then
          mv "$file" "$newname"
        else
          echo "Skipping (exists): $newname"
        fi
      fi
    done
  else
    echo "Directory not found: $dir"
  fi

done < ../../accession_species_clean.tsv
