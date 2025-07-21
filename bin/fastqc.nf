#! /usr/bin/env nextflow
//FastQC pipeline

//PARAMS
params.reads = "/workspaces/prime-seq/data/reads/SRR*_{1,2}.fastq.gz"
params.genome_index = "/workspaces/prime-seq/data/genome/genome_index.tar.gz"

process FastQC{
    container "community.wave.seqera.io/library/trim-galore:0.6.10--1bf8ca4e1967cd18"
    publishDir "/workspaces/prime-seq/results/FastQC", mode : "symlink", pattern: "*.{zip,html,txt}"
    publishDir "/workspaces/prime-seq/results/trimmed", mode : "symlink", pattern: "*.gz"
    
    input :
    tuple  path(read1), path(read2)

    output :
    tuple path("*_val_1.fq.gz"), path("*_val_2.fq.gz"), emit: trimmed_reads
    path "*_trimming_report.txt", emit: trimming_reports
    path "*_val_1_fastqc.{zip,html}", emit: fastqc_reports_1
    path "*_val_2_fastqc.{zip,html}", emit: fastqc_reports_2

    script:
    """
    trim_galore --fastqc --paired ${read1} ${read2}
    """

}
process Alignment{
    container "community.wave.seqera.io/library/hisat2_samtools:5e49f68a37dc010e"
    publishDir "/workspaces/prime-seq/results/aligned", mode : "symlink"

    input:
    tuple path(read1), path(read2)
    path index

    output:
    path "${read1.simpleName}*.bam", emit: bam
    path "${read1.simpleName}*.hisat2.log", emit: log


    script:
    """
    tar -xzvf $index
    hisat2 -x ${index.simpleName} -1 ${read1} -2 ${read2} \
        --new-summary --summary-file ${read1.simpleName}.hisat2.log | \
        samtools view -bS -o ${read1.simpleName}.bam
    """
}

workflow{
    read_ch = channel.fromFilePairs(params.reads, checkIfExists: true)
    tuple_path = read_ch.map{it[1]}
    
    ///read_ch.map{ id, files -> 
    ///            [id, files[1].simpleName]}.view()

    FastQC(tuple_path)
    FastQC.out.trimmed_reads.view()
    Alignment(FastQC.out.trimmed_reads, params.genome_index)
}

/*
workflow{
    read_idx = channel.fromPath(params.genome_index)
    prueba = read_idx.map {it.simpleName}
    prueba.view()
}
*/