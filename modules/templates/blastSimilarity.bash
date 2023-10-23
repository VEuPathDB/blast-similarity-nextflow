#!/usr/bin/env bash

set -euo pipefail

$blastProgram -db $databaseName \
	      -query $subsetFasta \
	      -outfmt "6 qseqid qlen sseqid slen qstart qend sstart send evalue bitscore length nident pident positive qframe sstrand gaps qseq" > out.txt

if [ "$printSimSeqs" = true ]; then

    printSimSeqs.pl \
     --result out.txt \
     --output blastSimilarity.out \
     --minLen $lengthCutoff \
     --minPercent $percentCutoff \
     --minPval $pValCutoff \
     --remMaskedRes $adjustMatchLength
    
else

    blastSimilarity.pl \
     --fasta $subsetFasta \
     --result out.txt \
     --output blastSimilarity.out \
     --minLen $lengthCutoff \
     --minPercent $percentCutoff \
     --minPval $pValCutoff \
     --remMaskedRes $adjustMatchLength \
     --outputType $outputType
    
fi
