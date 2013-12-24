#!/bin/bash
#$ -q genomics
#$ -j y
#$ -cwd
#$ -l h_vmem=10G
#$ -l virtual_free=10G
#$ -N cluster
. $HOME/.bashrc
export TEMPDIR=/genefs/MikheyevU/temp
export TMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp

K=5
run=1
#cluster informative genotypes
/apps/MikheyevU/popgen/NGSadmix -printInfo 1 -likes data/oceanica.bgl.gz -K $K -P 2 -minInd 60 -outfiles data/admix/"$K"_"$run"