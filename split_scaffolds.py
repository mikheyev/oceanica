from Bio import SeqIO
import sys
#take a scaffold file, and split into smaller chunks for GATK

seqlen = 0
seqs = []
for rec in SeqIO.parse(open(sys.argv[1]),"fasta"):
	seqlen+=len(rec.seq)
	seqs.append(rec.id)
	if seqlen >= 500000:
		seqlen = 0
		print "-L " + " -L ".join(seqs)
		seqs = []
if seqs:
	print "-L " + " -L ".join(seqs)