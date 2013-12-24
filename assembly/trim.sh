#!/bin/bash
#$ -q short
#$ -j y
#$ -cwd
#$ -l h_vmem=4G
#$ -l virtual_free=4G
#$ -N trim
. $HOME/.bashrc
export TEMPDIR=/genefs/MikheyevU/temp
export TMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp

a=(/genefs/SQC/Illumina/130809_SN1077_0126_AD2A38ACXX/Unaligned_NoIndex/Project_D2A38ACXX//Sample_lane7/*R1*gz)
b=(/genefs/SQC/Illumina/130809_SN1077_0126_AD2A38ACXX/Unaligned_NoIndex/Project_D2A38ACXX//Sample_lane7/*R2*gz)
f=${a[$SGE_TASK_ID-1]}
r=${b[$SGE_TASK_ID-1]}

trim_galore --dont_gzip --length 60 --retain_unpaired --output_dir ./trimmed --paired $f $r

#cp $f ./raw
#cp $r ./raw