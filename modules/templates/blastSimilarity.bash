#!/usr/bin/env bash

set -euo pipefail

/usr/bin/ncbi-blast-2.13.0+/bin/$blastProgram -db $databaseName -query $subsetFasta -outfmt "6 qseqid qlen sseqid slen qstart qend sstart send evalue bitscore length nident pident positive qframe sstrand gaps qseq" > out.txt

if [ "$printSimSeqs" = true ]; then

    perl /usr/bin/printSimSeqs.pl \
     --result out.txt \
     --output blastSimilarity.out \
     --minLen $lengthCutoff \
     --minPercent $percentCutoff \
     --minPval $pValCutoff \
     --remMaskedRes $adjustMatchLength
    
else

    perl /usr/bin/blastSimilarity.pl \
     --fasta $subsetFasta \
     --result out.txt \
     --output blastSimilarity.out \
     --minLen $lengthCutoff \
     --minPercent $percentCutoff \
     --minPval $pValCutoff \
     --remMaskedRes $adjustMatchLength \
     --outputType $outputType
    
fi
