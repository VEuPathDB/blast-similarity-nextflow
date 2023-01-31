#!/usr/bin/env bash

set -euo pipefail
mv $newdbfasta newdb.fasta

makeblastdb \
  -in newdb.fasta \
  -dbtype $params.databaseType
