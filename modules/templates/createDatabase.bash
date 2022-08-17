#!/usr/bin/env bash

set -euo pipefail
cp $params.databaseFasta newdb.fasta
makeblastdb \
  -in newdb.fasta \
  -dbtype $params.databaseType
