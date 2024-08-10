#!/bin/bash

module load Nextflow/23.10.0
module load FastQC/0.11.9-Java-11
module load BWA/0.7.17-GCCcore-11.3.0

nextflow run pipeline_map_reads.nf --with-dag -with-report -with-timeline
