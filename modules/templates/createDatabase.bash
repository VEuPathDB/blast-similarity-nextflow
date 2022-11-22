#!/usr/bin/env bash

set -euo pipefail

makeblastdb \
  -in newdb.fasta \
  -dbtype $params.databaseType
