#!/usr/bin/env python3

import csv
import os
import sys
import gzip
from collections import defaultdict
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
from Bio.Seq import Seq

if len(sys.argv) != 3:
    print("Usage: python extract_cluster_genbanks.py <antismash_dir> <cluster_membership.tsv>")
    sys.exit(1)

antismash_dir = sys.argv[1]
membership_tsv = sys.argv[2]

# ----------------------------
# Locate GenBank file
# ----------------------------
gbk_candidates = [
    "genomic.gbk",
    "genomic.gbff",
    "genomic.gbk.gz",
    "genomic.gbff.gz",
]

gbk_path = None
for fname in gbk_candidates:
    candidate = os.path.join(antismash_dir, fname)
    if os.path.exists(candidate):
        gbk_path = candidate
        break

if gbk_path is None:
    raise FileNotFoundError("Could not find genomic.gbk or genomic.gbff")

# ----------------------------
# Load cluster membership
# ----------------------------
cluster_to_loci = defaultdict(set)

with open(membership_tsv) as f:
    reader = csv.DictReader(f, delimiter="\t")
    for row in reader:
        cluster_id = row["cluster_id"]
        locus_tag = row["locus_tag"]
        cluster_to_loci[cluster_id].add(locus_tag)

# ----------------------------
# Helper: open possibly gzipped GBK
# ----------------------------
def open_gbk(path):
    if path.endswith(".gz"):
        return gzip.open(path, "rt")
    return open(path)

records = list(SeqIO.parse(open_gbk(gbk_path), "genbank"))

# ----------------------------
# Output directories
# ----------------------------
gbk_dir = os.path.join(antismash_dir, "cluster_genbanks")
faa_dir = os.path.join(antismash_dir, "cluster_fastas")

os.makedirs(gbk_dir, exist_ok=True)
os.makedirs(faa_dir, exist_ok=True)

written_gbk = 0
written_faa = 0

# ----------------------------
# Extract clusters
# ----------------------------
for cluster_id, loci in cluster_to_loci.items():
    cluster_records = []
    protein_records = []

    for record in records:
        new_features = []

        for feature in record.features:
            if feature.type != "CDS":
                continue

            locus_tags = feature.qualifiers.get("locus_tag", [])
            if not locus_tags:
                continue

            locus_tag = locus_tags[0]

            if locus_tag in loci:
                new_features.append(feature)

                # ---- FAA extraction ----
                if "translation" in feature.qualifiers:
                    protein_seq = feature.qualifiers["translation"][0]
                    product = feature.qualifiers.get("product", ["unknown"])[0]

                    prot_record = SeqRecord(
                        Seq(protein_seq),
                        id=locus_tag,
                        description=product
                    )
                    protein_records.append(prot_record)

        if new_features:
            new_record = SeqRecord(
                seq=record.seq,
                id=record.id,
                name=record.name,
                description=f"Cluster {cluster_id}",
                annotations=record.annotations.copy()
            )
            new_record.features = new_features
            cluster_records.append(new_record)

    # ----------------------------
    # Write outputs
    # ----------------------------
    if cluster_records:
        gbk_out = os.path.join(gbk_dir, f"{cluster_id}.gbk")
        SeqIO.write(cluster_records, gbk_out, "genbank")
        written_gbk += 1

    if protein_records:
        faa_out = os.path.join(faa_dir, f"{cluster_id}.faa")
        SeqIO.write(protein_records, faa_out, "fasta")
        written_faa += 1

print(f"Wrote {written_gbk} cluster GBK files to {gbk_dir}")
print(f"Wrote {written_faa} cluster FAA files to {faa_dir}")

