#! /usr/bin/env nextflow
//FastQC pipeline

//PARAMS
///params.reads = "/workspaces/prime-seq/data/reads/SRR*_{1,2}.fastq.gz"
params.reads = "/workspaces/prime-seq/data/reads/SRR*1_{1,2}.fastq.gz"
params.genome_index = "/workspaces/prime-seq/data/genome/genome_index.tar.gz"
params.barcodes = "/workspaces/prime-seq/data/barcodes_whitelist.tsv"
params.bc_pattern = '(?P<umi_1>.{18})(?P<cell_1>.{10})$'

process Extract_barcodes{
    container "community.wave.seqera.io/library/umi_tools:1.1.6--2c79f13606642e4c"
    ///publishDir "/workspaces/prime-seq/results/Extracted", mode: "symlink"
    publishDir "/workspaces/prime-seq/bin/results/Extracted", mode : "copy"

    input :
    path barcodes
    tuple  path(read1), path(read2)
    val bc_pattern

    output :
    tuple path("*1_extracted.fastq.gz"), path("*2_extracted.fastq.gz"), emit: extracted_reads

    script:
    """
    umi_tools extract --extract-method=regex --bc-pattern="'${bc_pattern}'" --stdin=${read1} --stdout=${read1.simpleName}_extracted.fastq.gz \
     --read2-in=${read2} --read2-out=${read2.simpleName}_extracted.fastq.gz --filter-cell-barcode --whitelist=${barcodes}
    """
}
process FastQC{
    container "community.wave.seqera.io/library/trim-galore:0.6.10--1bf8ca4e1967cd18"
    publishDir "/workspaces/prime-seq/results/FastQC", mode : "symlink", pattern: "*.{zip,html,txt}"
    ///publishDir "/workspaces/prime-seq/results/trimmed", mode : "symlink", pattern: "*.gz"
    publishDir "/workspaces/prime-seq/bin/results/trimmed", mode : "copy", pattern: "*.gz"

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
    hisat2 -x ${index.simpleName} -1 ${read1} -2 ${read2} \
        --new-summary --summary-file ${read1.simpleName}.hisat2.log | \
        samtools view -bS -o ${read1.simpleName}.bam
    """
}
process umi_dedup {
    container "community.wave.seqera.io/library/umi_tools:1.1.6--2c79f13606642e4c"
    publishDir "/workspaces/prime-seq/results/umi_dedup", mode: 'copy'

    input:
    tuple val(sample_id), path(aligned_bam)

    output:
    tuple val(sample_id), path("deduplicated.bam")

    script:
    """
    umi_tools dedup \
        -I $aligned_bam \
        -S deduplicated.bam \
        --output-stats=dedup_stats.txt
    """
}
process feature_counting {
    tag "$sample_id"
    container 'quay.io/biocontainers/subread:2.0.1--h7132678_1'
    publishDir "/workspaces/prime-seq/results/feature_counts", mode: 'copy'

    input:
    tuple val(sample_id), path(bam_file)
    path gtf_file

    output:
    tuple val(sample_id), path("counts.txt")

    

    script:
    """
    featureCounts \
        -a $gtf_file \
        -o counts.txt \
        -R BAM \
        -T 4 \
        -t exon \
        -g gene_id \
        $bam_file
    """
}
workflow{
    ///barcode_val = params.barcodes
    ///barcode_val.view()
    barcode_ch = Channel.fromPath(params.barcodes)
    read_ch = channel.fromFilePairs(params.reads, checkIfExists: true)
    read_tuple = read_ch.map{it[1]}
    FastQC(read_tuple)
    FastQC.out.trimmed_reads.map{it.simpleName}.view()
    ///println "¿Existe el archivo barcodes?: ${file(params.barcodes).exists()}"
    Extract_barcodes(params.barcodes, FastQC.out.trimmed_reads, params.bc_pattern)
    ///read_tuple.view()
    ///Extract_barcodes(barcode_val, read_tuple, params.bc_pattern)
    ///Extract_barcodes.out.extracted_reads.view()
    ///read_ch.map{ id, files -> 
    ///            [id, files[1].simpleName]}.view()

    
    ///Alignment(FastQC.out.trimmed_reads, params.genome_index)
}

/*
workflow{
    read_idx = channel.fromPath(params.genome_index)
    prueba = read_idx.map {it.simpleName}
    prueba.view()
}
*/