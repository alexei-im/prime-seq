#!/bin/bash -ue
hisat2 -x genome_index -1 SRR005_1_val_1.fq.gz -2 SRR005_2_val_2.fq.gz         --new-summary --summary-file SRR005_1_val_1.hisat2.log |         samtools view -bS -o SRR005_1_val_1.bam
