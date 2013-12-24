#!/bin/bash
#$ -q long
#$ -j y
#$ -cwd
#$ -N pca
#$ -l h_vmem=47G
#$ -l virtual_free=47G

. $HOME/.bashrc

export TEMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp

# compute genotype posterior probabilities
#/apps/MikheyevU/popgen/angsd/angsd -nThreads 12 -bam data/all.txt -nInd 130 -doGeno 32 -doPost 1 -doMaf 2 -doMajorMinor 1 -doSNP 1 -minQ 20 -minLRT 24 -GL 4 -doCounts 1 -out data/all

find data/all.covar -delete

# compute pca
/apps/MikheyevU/popgen/ngsTools/bin/ngsCovar -probfile data/all.geno -outfile data/all.covar -nind 130 -nsites 1000 -call 0 -minmaf 0.05 