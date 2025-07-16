#! /usr/bin/env nextflow
//FastQC pipeline

process FastQC{
    container "community.wave.seqera.io/library/trim-galore:0.6.10--1bf8ca4e1967cd18"
    publishDir "results/FastQC", mode : "symlink"
    
    input :
    tuple path(read1), path(read2)

    output :
    tuple path("*_val_1.fq.gz"), path("*_val_2.fq.gz"), emit: trimmed_reads
    path "*_trimming_report.txt", emit: trimming_reports
    path "*_val_1_fastqc.{zip,html}", emit: fastqc_reports_1
    path "*_val_2_fastqc.{zip,html}", emit: fastqc_reports_2

    

    script:
    """
    fastqc --fastqc --paired ${read1} ${read2}
    """

}
workflow{
    Channel.fromFilePairs("${projectDir}/data/reads/SRR*_{1,2}.fastq.gz").
    view()

}