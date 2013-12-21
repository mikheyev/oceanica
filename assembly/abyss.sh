#!/bin/bash
#$ -N abyss
#$ -q long
#$ -j y
##$ -m ea
#$ -cwd
#$ -l mf=40G
#$ -l h_vmem=40G
. $HOME/.bashrc

export TEMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp
export TMPDIR=/genefs/MikheyevU/temp 

rm -r k$SGE_TASK_ID
mkdir k$SGE_TASK_ID
dir=$(pwd)
cd k$SGE_TASK_ID
abyss-pe name=oceanica j=2 k=$SGE_TASK_ID in='../trimmed/trimmed_1.fastq ../trimmed/trimmed_2.fastq' se='../trimmed/trimmed_u.fastq'
