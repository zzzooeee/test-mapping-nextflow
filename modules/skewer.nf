#!/usr/bin/env nextflow

// Process trimmomatic
process skewer {
  publishDir "${params.outdir}/trimmed-reads-${sample}", mode: 'copy'

  // Same input as fastqc on raw reads, comes from the same channel. 
  input:
  tuple val(sample), path(reads) 

  output:
  tuple val("${sample}"), path("${sample}-trimmed-pair*"), emit: paired_fq

  script:
  """
  /vscmnt/brussel_pixiu_home/_user_brussel/109/vsc10919/skewer-0.2.2-linux-x86_64 -o ${sample} ${reads[0]} ${reads[1]} -o ${sample} -q ${params.mingqual} -l ${params.minlength} -m pe
  gzip ${sample}-trimmed-pair1.fastq
  gzip ${sample}-trimmed-pair2.fastq
 
  """
}
