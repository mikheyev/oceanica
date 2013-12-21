#!/bin/bash
#$ -q long
#$ -j y
#$ -cwd
#$ -N oceanica_call2
#$ -l h_vmem=4G
#$ -l virtual_free=4G

. $HOME/.bashrc

export TEMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp
MAXMEM=3

ref=ref/oceanica_long.fa
alias GA="java -Xmx"$MAXMEM"g -Djava.io.tmpdir=/genefs/MikheyevU/temp -jar /apps/MikheyevU/sasha/GATK/GenomeAnalysisTK.jar"

old_IFS=$IFS
IFS=$'\n'
a=($(cat ref/scaffolds.txt)) #473
IFS=$old_IFS
limit=${a[$SGE_TASK_ID-1]}

GA \
    -T HaplotypeCaller\
    -A QualByDepth -A RMSMappingQuality -A HaplotypeScore -A InbreedingCoeff -A MappingQualityRankSumTest -A Coverage -A ReadPosRankSumTest -A BaseQualityRankSumTest -A ClippingRankSumTest \
    -R $ref \
    -I data/merged.recal.bam \
    $limit \
    --genotyping_mode DISCOVERY \
    --heterozygosity 0.005 \
    -o data/variants/$SGE_TASK_ID.vcf
