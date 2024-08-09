#!/usr/bin/env nextflow


// Set parameters
params.reads = "${launchDir}/data/*R{1,2}.fastq.gz"
params.outdir = "${launchDir}/results"
params.threads = 2
params.slidingwindow = "SLIDINGWINDOW:4:15"
params.avgqual = "AVGQUAL:30"


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
read_pairs_ch = Channel
        .fromFilePairs(params.reads, checkIfExists:true)

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
