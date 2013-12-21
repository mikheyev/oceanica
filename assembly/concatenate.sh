#!/bin/bash
#$ -q short
#$ -j y
#$ -cwd
#$ -l h_vmem=4G
#$ -l virtual_free=4G
#$ -N gather
. $HOME/.bashrc
export TEMPDIR=/genefs/MikheyevU/temp
export TMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp

cat trimmed/*unpaired*.fq  > trimmed/trimmed_u.fastq
cat trimmed/*val_1.fq  > trimmed/trimmed_1.fastq
cat trimmed/*val_2.fq  > trimmed/trimmed_2.fastq