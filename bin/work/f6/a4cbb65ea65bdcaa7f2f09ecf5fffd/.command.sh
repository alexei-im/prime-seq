#!/bin/bash -ue
hisat2 -x genome_index -1 SRR002_1_val_1.fq.gz -2 SRR002_2_val_2.fq.gz         --new-summary --summary-file SRR002_1_val_1.hisat2.log |         samtools view -bS -o SRR002_1_val_1.bam
