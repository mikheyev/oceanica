#!/bin/bash
#$ -q long
#$ -j y
#$ -cwd
#$ -N align
#$ -l h_vmem=10G
#$ -l virtual_free=10G

. $HOME/.bashrc
#SGE_TASK_ID=2
a=(data/raw/*/*gz) #180
b=(*2.fastq)
f=${a["SGE_TASK_ID"-1]} 
bowbase=ref/oceanica_long
base=$(echo $f | cut -d "/" -f3 |sed 's/Sample_//')
ref=ref/oceanica_long.fa 
export TEMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp

alias GA="java -Xmx8g -jar /apps/MikheyevU/sasha/GATK/GenomeAnalysisTK.jar"

bowtie2 -p 2 --very-sensitive-local --phred33 --sam-rg ID:$base --sam-rg LB:degraded --sam-rg SM:$base --sam-rg PL:ILLUMINA  -x $bowbase -U $f  | samtools view -Su - | novosort -c 1 -t  /genefs/MikheyevU/temp -i -o data/aligned/$base.bam -

GA -nt 4 \
   -I data/aligned/$base.bam \
   -R $ref \
   -T RealignerTargetCreator \
   -o data/aligned/$base"_IndelRealigner.intervals" 

GA  \
   -I data/aligned/$base.bam \
   -R $ref \
   -T IndelRealigner \
   -targetIntervals data/aligned/$base"_IndelRealigner.intervals" \
   --maxReadsInMemory 1000000 \
   --maxReadsForRealignment 100000 \
   -o data/aligned/$base.realigned.bam

samtools index data/aligned/$base.realigned.bam
