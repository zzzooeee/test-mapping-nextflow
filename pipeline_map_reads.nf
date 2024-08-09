#!/usr/bin/env nextflow


// input data
params.reads = "${launchDir}/data/*{1,2}.fastq.gz"
params.genome = "${launchDir}/data/GCF_000001405.40_GRCh38.p14_genomic.fna.gz"
params.outdir = "${launchDir}/results"
params.threads = 2
params.minlength = 51
params.mingqual = 30


// Create channels. 
read_pairs_ch = Channel
        .fromFilePairs(params.reads, checkIfExists:true)
genome = Channel
      .fromPath(params.genome, checkIfExists:true)



include { fastqc as fastqc_raw; fastqc as fastqc_trim } from "${projectDir}/modules/fastqc" 
include { skewer } from "${projectDir}/modules/skewer"
include { index ; mapping_bwa } from "${projectDir}/modules/genome_mapping"


// Run workflow.  
workflow {
  fastqc_raw(read_pairs_ch) 
  skewer(read_pairs_ch)
  fastqc_trim(skewer.out.paired_fq)
  index(genome)
  mapping_bwa(index.out, skewer.out.paired_fq)
}
