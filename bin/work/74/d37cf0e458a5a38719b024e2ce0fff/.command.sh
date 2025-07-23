#!/bin/bash -ue
umitools extract   --extract-method=regex   --bc-pattern="'(?P<umi_1>.{18})(?P<cell_1>.{10})$'"   --stdin=SRR005_1.fastq.gz 
--stdout=SRR005_11_extracted.fastq.gz   --read2-in=SRR005_2.fastq.gz   --read2-out=SRR005_12_extracted.fastq.gz   --filter-cell-barcode   --whitelist=barcodes_whitelist.tsv
