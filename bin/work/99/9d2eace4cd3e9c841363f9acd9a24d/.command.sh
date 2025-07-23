#!/bin/bash -ue
umi_tools extract --extract-method=regex --bc-pattern="'(?P<umi_1>.{18})(?P<cell_1>.{10})$'" --stdin=SRR001_1.fastq.gz --stdout=SRR001_1_extracted.fastq.gz      --read2-in=SRR001_2.fastq.gz --read2-out=SRR001_2_extracted.fastq.gz --filter-cell-barcode --whitelist=/workspaces/prime-seq/data/barcodes_whitelist.tsv
