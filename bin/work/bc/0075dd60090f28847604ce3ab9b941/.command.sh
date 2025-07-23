#!/bin/bash -ue
umi_tools extract --extract-method=regex --bc-pattern="'(?P<umi_1>.{18})(?P<cell_1>.{10})$'" --stdin=SRR003_1_val_1.fq.gz --stdout=SRR003_1_val_1_extracted.fastq.gz      --read2-in=SRR003_2_val_2.fq.gz --read2-out=SRR003_2_val_2_extracted.fastq.gz --filter-cell-barcode --whitelist=/workspaces/prime-seq/data/barcodes_whitelist.tsv
