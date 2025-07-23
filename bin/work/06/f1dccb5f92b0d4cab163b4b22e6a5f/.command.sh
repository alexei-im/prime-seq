#!/bin/bash -ue
umi_tools extract   --extract-method=regex   --bc-pattern="'(?P<umi_1>.{18})(?P<cell_1>.{10})$'"   --stdin=SRR005_1.fastq.gz 
--stdout=SRR005_1_extracted.fastq.gz   --read2-in=SRR005_2.fastq.gz   --read2-out=SRR005_1_extracted.fastq.gz   --filter-cell-barcode   --whitelist=barcodes_whitelist.tsv
