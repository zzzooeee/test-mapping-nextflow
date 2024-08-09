#!/usr/bin/env nextflow


// Similar to DSL1, the input data is defined in the beginning.
params.genome = "${launchDir}/ncbi_dataset/data/GCF_000001405.40/GCF_000001405.40_GRCh38.p14_genomic.fna.gz"
params.outdir = "${launchDir}/results"

log.info """\
      LIST OF PARAMETERS
================================
Reads            : ${params.reads}
Output-folder    : ${params.outdir}/
"""

// Also channels are being created. 
genome = Channel
      .fromPath(params.genome, checkIfExists:true)
      
// INDEX GENOME
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

workflow {
	index(genome)
}