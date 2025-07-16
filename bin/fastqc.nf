#! /usr/bin/env nextflow
//FastQC pipeline

//PARAMS
params.reads = "/workspaces/prime-seq/data/reads/SRR*_{1,2}.fastq.gz"

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
process PRUEBA{
    input:
    tuple val(prefix), path(reads)
    output:
    stdout
    script:
    """
    echo "${prefix} con ${reads[0]} con ${reads[1]}"
    """

}
process PRUEBA1 {
    publishDir "results", mode: "symlink"
    
    input:
    tuple val(prefix), path(reads)
    
    output:

    path "info.txt"

    script:
    """
    echo "Prefijo: ${prefix}" > info.txt
    echo "Archivos: ${reads[0]} y ${reads[1]}" >> info.txt
    """
}

workflow{
    read_ch = channel.fromFilePairs(params.reads, checkIfExists: true)
    read_ch.view()
    PRUEBA1(read_ch)
}
