# Nextflow pipeline to align reads to genome

With nextflow I created a pipeline to align paired end reads to a reference genome, a quick overview can be seen in the DAG flow chart. This pipeline takes as input paired end reads and a reference gneome and outputs the mapped reads to the reference genome with quality controls for different steps. 


![alt text](https://github.com/zzzooeee/test-mapping-nextflow/blob/main/reports/dag-chart.png)



## Genome mapping pipeline
### Channels

Two channels are created, one with the paired end read data and one with the genome data. 

### Workflow

1. **Quality check raw reads** \
   This was done with fastqc, which provides a report with different quality measures \
   *Process fastqc from module fastqc* 

3. **Trim adapters and remove low quality reads** 
   With Skewer, the adapters of the reads are removed. Subsequently, reads below a chosen length and quality score are removed. \
   *Process skewer from module skewer* 

5. **Verify quality trimmed reads**
   Second quality check of the trimmed and filtered reads with fastqc. \
   *Process fastqc from module fastqc* 

7. **Index reference genome**
   The reference genome is indexed using the BWA indexer \
   *Process index from module genome_mapping* 

9. **Align reads to reference genome**
    Reads are aligned to the reference genome using BWA mem. The mappings are sorted and summary statitics are outputted with SAMtools. \
    *Process mapping_bwa from module genome_mapping* 

### Run the pipeline

```
nextflow run pipeline_map_reads.nf --reads --genome --outdir --threads --minlength --mingqual
```

The pipeline will run with the following default parameters, but these can be changed in the command as shown above
default input values \
reads = "${launchDir}/data/*{1,2}.fastq.gz" - paired end input reads \
genome = "${launchDir}/data/GCF_000001405.40_GRCh38.p14_genomic.fna.gz" -reference genome \
outdir = "${launchDir}/results" - output directory \
threads = 2 - number of threads for the pipeline to use \
minlength = 51 - minimum length of retained reads (Skewer) \
mingqual = 30 - minimum quality score of retained reads (Skewer) 


**Run on the HPC** 

This script loads all the necessary programs (inlcuding nextflow) to run the nextflow pipeline. To run this script in other environments, the programs would have to be embedded differently in the pipeline. 

```
./run_mapping_nextflow.sh
```

## Suggested improvements on the pipeline

To run this script in other environments, cluster, clouds,..., the programs needed would have to be embedded differently in the pipeline, through the config files and containers.
It would also be good to add a step to check if the genome is already indexed,and skip this step if the index is already available.

## Source reference genome
https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000001405.40/



