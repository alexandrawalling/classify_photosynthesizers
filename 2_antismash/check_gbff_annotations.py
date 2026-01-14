#!/usr/bin/env python3


import sys
from pathlib import Path
from Bio import SeqIO
import gzip


if len(sys.argv) != 2:
    print("Usage: check_cds_features.py <input_genome_dir_list.txt>")
    sys.exit(1)


input_list = Path(sys.argv[1])
needs_prodigal = Path("prodigal.tsv")
no_prodigal = Path("normal.tsv")
error_log = Path("errors.log")


with input_list.open() as infile, \
     needs_prodigal.open("w") as out_yes, \
     no_prodigal.open("w") as out_no, \
     error_log.open("w") as errlog:

    out_yes.write("genome_dir\tinput_file\tneeds_prodigal\n")
    out_no.write("genome_dir\tinput_file\tneeds_prodigal\n")

    for line in infile:
        genome_dir = line.strip()
        if not genome_dir:
            continue

        gbff_file = Path(genome_dir) / "genomic.gbff.gz"

        if not gbff_file.exists():
            errlog.write(f"Missing file: {gbff_file}\n")
            continue

        has_cds = False

        try:
            with gzip.open(gbff_file, "rt") as handle:
                for record in SeqIO.parse(handle, "genbank"):
    
                    for feature in record.features:
                        if feature.type == "CDS":
                            has_cds = True
                            break
                    if has_cds:
                        break
        except Exception as e:
            errlog.write(f"Parsing error in {gbff_file}: {e}\n")
            continue

        line_out = f"{genome_dir}\t{gbff_file}\t"
        if has_cds:
            out_no.write(line_out + "no\n")
        else:
            out_yes.write(line_out + "yes\n")

