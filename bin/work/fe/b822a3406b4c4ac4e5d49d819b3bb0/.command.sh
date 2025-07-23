#!/bin/bash -ue
umi_tools extract --extract-method=regex --bc-pattern="'(?P<umi_1>.{18})(?P<cell_1>.{10})$'" --stdin=SRR002_1_val_1.fq.gz --stdout=SRR002_1_val_1_extracted.fastq.gz      --read2-in=SRR002_2_val_2.fq.gz --read2-out=SRR002_2_val_2_extracted.fastq.gz --whitelist=barcodes_whitelist.tsv
