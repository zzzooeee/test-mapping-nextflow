#!/usr/bin/env nextflow


process index {
  publishDir "${params.outdir}/genome/", mode: 'copy', overwrite: true

  input:
  path(genome)

  output:
  path("*")
  
  script:
  """
  bwa index $genome

  """
}



process mapping_bwa {
  publishDir "${params.outdir}/mapping-${sample}", mode: 'copy'

  // Same input as fastqc on raw reads, comes from the same channel. 
  input:
  path bwa_index
  tuple val(sample), path(read_pairs) 

  output:
  path("*.bam"), emit: bam
  path("*.stats"), emit: stats

  script:

  def idxbase = bwa_index[0].baseName
  """
  bwa mem "${idxbase}" ${read_pairs[0]} ${read_pairs[1]} | samtools sort -O bam > "${sample}.bam"
  samtools stats "${sample}.bam" > "${sample}.stats"
  """
}