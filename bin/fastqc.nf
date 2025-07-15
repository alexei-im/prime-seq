#! /usr/bin/env nextflow
//FastQC pipeline

process FastQC{
    container "community.wave.seqera.io/library/trim-galore:0.6.10--1bf8ca4e1967cd18"
    publishDir "results/FastQC", mode : "symlink"
    
    input :
    path reads

    output :
    path $reads, zip
    path $reads, html

    script:
    """
    fastqc $reads
    """

}