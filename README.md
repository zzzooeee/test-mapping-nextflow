# Nextflow pipeline to align reads to genome

With nextflow I created a pipeline to align paired end reads to a reference genome.  


## Pipeline

![alt text](https://github.com/zzzooeee/test-mapping-nextflow/blob/main/dag-chart.png)




###Channels

Two channels are created, one with the paired end read data and one with the genome data. 

###Workflow

1. **Quality check raw reads**
   This was done with fastqc, which provides a report with different quality measures
   *Process fastqc from module fastqc*

3. **Trim adapters and remove low quality reads**
   With Skewer, the adapters of the reads are removed. Subsequently, reads below a chosen length and quality score are removed. 
   *Process skewer from module skewer*

5. **Verify quality trimmed reads**
   Second quality check of the trimmed and filtered reads with fastqc.
   *Process fastqc from module fastqc*

7. **Index reference genome**
   The reference genome is indexed using the BWA indexer
   *Process index from module genome_mapping*

9. **Align reads to reference genome**
    Reads are aligned to the reference genome using BWA mem. The mappings are sorted and summary statitics are outputted with SAMtools. 
    *Process mapping_bwa from module genome_mapping*

### Run the pipeline

```
nextflow run pipeline_map_reads.nf --reads --genome --outdir --threads --minlength --mingqual
```

The default input values
reads = "${launchDir}/data/*{1,2}.fastq.gz" - paired end input reads
genome = "${launchDir}/data/GCF_000001405.40_GRCh38.p14_genomic.fna.gz" -reference genome
outdir = "${launchDir}/results" - output directory
threads = 2 - number of threads for the pipeline to use
minlength = 51 - minimum length of retained reads (Skewer)
mingqual = 30 - minimum quality score of retained reads (Skewer)



## Data 
Source reference genome : https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000001405.40/



