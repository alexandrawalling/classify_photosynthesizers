#!/usr/bin/env python3

import json
import re
import csv
import sys
import os

if len(sys.argv) != 2:
    print("Usage: python extract_cluster_membership.py <antismash_results_dir>")
    sys.exit(1)

input_dir = sys.argv[1]
input_path = os.path.join(input_dir, "regions.js")
output_path = os.path.join(input_dir, "cluster_membership.tsv")

# ----------------------------
# Load and extract JSON array
# ----------------------------
with open(input_path) as f:
    raw = f.read()

match = re.search(
    r"var\s+recordData\s*=\s*(\[\s*.*?\s*\])\s*;",
    raw,
    re.DOTALL
)

if not match:
    raise ValueError("Could not extract recordData array from regions.js")

record_data = json.loads(match.group(1))

# ----------------------------
# Extract cluster membership
# ----------------------------
rows = []

for record in record_data:
    seq_id = record.get("seq_id")

    for region in record.get("regions", []):
        region_idx = region.get("idx")

        orfs = region.get("orfs", [])
        clusters = region.get("clusters", [])

        for cluster_idx, cluster in enumerate(clusters):
            cluster_start = cluster.get("neighbouring_start")
            cluster_end = cluster.get("neighbouring_end")

            product = cluster.get("product")
            category = cluster.get("category")
            tool = cluster.get("tool")
            kind = cluster.get("kind")

            cluster_id = f"{seq_id}_r{region_idx}_c{cluster_idx}"

            for orf in orfs:
                orf_start = orf.get("start")
                orf_end = orf.get("end")
                locus_tag = orf.get("locus_tag")
                gene_type = orf.get("type")

                if (
                    orf_start is not None
                    and orf_end is not None
                    and cluster_start is not None
                    and cluster_end is not None
                    and orf_start >= cluster_start
                    and orf_end <= cluster_end
                ):
                    rows.append([
                        locus_tag,
                        seq_id,
                        region_idx,
                        cluster_id,
                        cluster_start,
                        cluster_end,
                        product,
                        category,
                        tool,
                        kind,
                        gene_type
                    ])

# ----------------------------
# Write TSV
# ----------------------------
with open(output_path, "w", newline="") as out_f:
    writer = csv.writer(out_f, delimiter="\t")
    writer.writerow([
        "locus_tag",
        "seq_id",
        "region_idx",
        "cluster_id",
        "cluster_start",
        "cluster_end",
        "product",
        "category",
        "tool",
        "cluster_kind",
        "orf_type"
    ])
    writer.writerows(rows)

print(f"Wrote {len(rows)} rows to {output_path}")

