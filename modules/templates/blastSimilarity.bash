#!/usr/bin/env bash

set -euo pipefail
blastSimilarity.pl \
  --pValCutoff  $pValCutoff \
  --lengthCutoff $lengthCutoff \
  --percentCutoff $percentCutoff \
  --blastProgram $blastProgram \
  --database $fastaName \
  --seqFile $subsetFasta  \
  --doNotParse $doNotParse \
  --printSimSeqsFile $printSimSeqsFile \
  --saveAllBlastFiles $saveAllBlastFiles \
  --saveGoodBlastFiles $saveGoodBlastFiles \
  --remMaskedRes $adjustMatchLength \
  --blastArgs $blastArgs
