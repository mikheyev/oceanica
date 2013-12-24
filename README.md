# Phylogeography of the Pheidole oceanica species complex

Testing the FASSST genotyping approach on a several related pan-Pacific species

## Genome assembly

Assembled using abyss assembled a lane of HiSeq 2000 PE100 data with a range of kmers from 61 to 95. Chose 61 as the best one, giving the longest assembly, with the highest N50. These scaffolds were then filtered to remove onew < 500 bp in length.

## Mapping raw reads

**aligh.sh** maps raw reads using bowtie2 and performs local realignment around indels with GATK

## SNP calling with GATK

After initial snp calling (**call1.sh**) and base quality recalibration with **bqsr.sh**, call SNPs again (**call2.sh**). Tried to to VQSR, but it did not perform particularly well, predominantly throwing out sites without missing data, and keeping sites with missing data, so I skipped this step.

## PCA analysis

After SNP calling, removed sites with > 30% missing data (see below), and then individuals with >50% missing data (50).

	awk 'NR>1 && $NF > .5 {print $1} '  missing7.imiss > too_much_missing.txt

These individuals were used to compute PCA (**pca.sh**) using the raw input files

## ngsAdmix (not finished)

Call SNPs and create a genotype likelihood file

	/apps/MikheyevU/popgen/angsd/angsd -GL 1 -out genolike -nThreads 10 -doGlf 2 -doMajorMinor 1 -minLRT 24 -doMaf 2 -doSNP 2 -bam data/all.txt

**To do:** actually run the analysis 

## Tabulating data

filtering vcf to exclude individuals with too much missing data, and only bi-allelic sites, and  any individuals with GQ < 13

	vcftools --vcf data/raw1.vcf --recode --minGQ 13 --remove data/too_much_missing.txt --minQ 20 --min-alleles 2 --max-alleles 2 --out data/raw.highGQ

	vcftools --vcf data/raw.highGQ.recode.vcf --recode  --geno 0.7 --out data/raw.highGQ.lowMissing7  #these two steps need to be split or they don't work

	cat data/raw.highGQ.lowMissing7.recode.vcf | vcf-to-tab | awk -v OFS=, 'NR == 1 {$1=$1;print} NR > 1 {for(i=4;i<=NF;i++) {split($i,a,"/") ;if (a[1]==".") $i="?"; else if (a[1]!=a[2]) $i="H"; else if (a[1] == $3) $i="R"; else $i="A"}; print }' > data/raw.highGQ.lowMissing7.recode.csv