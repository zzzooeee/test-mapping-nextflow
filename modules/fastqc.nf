#!/usr/bin/env nextflow

process fastqc {
  publishDir "${params.outdir}/quality-control-${sample}/", mode: 'copy'
  
  input:
  tuple val(sample), path(reads)  
  output:
  path("*_fastqc.{zip,html}") 

  script:
  """
  fastqc ${reads}
  """
}
