#!/bin/bash
#$ -q genomics
#$ -j y
#$ -cwd
#$ -N ant
#$ -l h_vmem=10G
#$ -l virtual_free=10G

. $HOME/.bashrc
export TEMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp

MAXMEM=8
ref=./ref/oceanica_long.fa 

inputs=`for i in data/aligned/*realigned.bam ; do echo -ne "-I "$i" "; done`

alias GA="java -Xmx"$MAXMEM"g -Djava.io.tmpdir=/genefs/MikheyevU/temp -jar /apps/MikheyevU/sasha/GATK/GenomeAnalysisTK.jar"

# Gathering results from call1.sh

(grep ^# data/variants/1.vcf; for i in `seq 1 473`; do grep -v ^# data/variants/$i.vcf ; done) > data/raw1.vcf

# Running another independet SNP caller

samtools mpileup -ugf $ref data/aligned/*realigned.bam | bcftools view -vcg - | vcfutils.pl varFilter -Q 20 > data/samtools.vcf


# #Finding sites in common between the two approaches

(grep ^# data/raw1.vcf ;  intersectBed -wa -f 1.0 -sorted -a data/samtools.vcf -b data/raw1.vcf ) > data/samtools_gatk1.vcf


# Applying base quality recalibration using the set of sites found by both callers

GA \
   -nct 12 \
   -T BaseRecalibrator \
   $inputs  \
   -R $ref \
   -knownSites data/samtools_gatk1.vcf \
   -o data/recal_data.table

# Prining recalibrated BAM file

 GA \
    -nct 12 \
    -T PrintReads \
    $inputs \
    -R $ref  \
    -BQSR data/recal_data.table \
    -o data/merged.recal.bam

# Preparing comparison between recalibrated and non-recalibrated data

GA \
   -nct 12 \
   -T BaseRecalibrator \
   -I data/merged.recal.bam  \
   -R $ref \
   -knownSites data/samtools_gatk1.vcf \
   -BQSR data/recal_data.table \
   -o data/post_recal_data.table

# Preparing PDF files with comparison between recalibrated and non-recalibrated data

GA \
    -T AnalyzeCovariates \
    -R $ref \
    -before data/recal_data.table \
    -after data/post_recal_data.table \
    -plots data/recalibration_plots.pdf
