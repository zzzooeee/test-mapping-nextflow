#!/usr/bin/env nextflow


// Set parameters
params.reads = "${launchDir}/results/trimmed-reads-GC146638_xplus.100k.R/*R{1,2}_P.fq"
//params.genome = "${launchDir}/data/GCF_000001405.40_GRCh38.p14_genomic.fna.gz*"
params.outdir = "${launchDir}/results/"

//bwa_index = file( '${launchDir}/data/GCF_000001405.40_GRCh38.p14_genomic.fna.gz.{,amb,ann,bwt,pac,sa}' )


log.info """\
      LIST OF PARAMETERS
================================
            GENERAL
Reads            : ${params.reads}
Output-folder    : ${params.outdir}

          TRIMMOMATIC
Threads          : ${params.threads}
Sliding window   : ${params.slidingwindow}
Avg quality      : ${params.avgqual}
"""

// Also channels are being created. 
read_pairs = Channel
        .fromFilePairs(params.reads, checkIfExists:true)
//genome = Channel
//      .fromPath(params.genome, checkIfExists:true)


// Process trimmomatic
process mapping_bwa {
  publishDir "${params.outdir}/mapping", mode: 'copy'

  // Same input as fastqc on raw reads, comes from the same channel. 
  input:
  path bwa_index
  tuple val(sample), path(read_pairs) 

  output:
  path("*.bam"), emit: bam

  script:

  def idxbase = bwa_index[0].baseName
  """
  bwa mem "${idxbase}" ${read_pairs[0]} ${read_pairs[1]} | samtools sort -O bam > "${sample}.bam"
  """
}

workflow {
  bwa_index = file( '/vscmnt/brussel_pixiu_home/_user_brussel/109/vsc10919/data/GCF_000001405.40_GRCh38.p14_genomic.fna.gz.{,amb,ann,bwt,pac,sa}' )
  mapping_bwa(bwa_index, read_pairs)
}