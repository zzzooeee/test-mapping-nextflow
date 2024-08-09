#!/usr/bin/env nextflow

// Process trimmomatic
process trimmomatic {
  publishDir "${params.outdir}/trimmed-reads-${sample}", mode: 'copy'

  // Same input as fastqc on raw reads, comes from the same channel. 
  input:
  tuple val(sample), path(reads) 

  output:
  tuple val("${sample}"), path("${sample}*_P.fq"), emit: paired_fq
  tuple val("${sample}"), path("${sample}*_U.fq"), emit: unpaired_fq

  script:
  """
  java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar PE -threads ${params.threads} ${reads[0]} ${reads[1]} ${sample}1_P.fq ${sample}1_U.fq ${sample}2_P.fq ${sample}2_U.fq ${params.slidingwindow} ${params.avgqual} 
  """
}
