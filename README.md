# blast-similarity-nextflow

A Nextflow pipeline that computes sequence similarity between a query FASTA file and a target database using NCBI BLAST+.

## Overview

This pipeline runs any NCBI BLAST+ program (`blastn`, `blastp`, `blastx`, etc.) to compare a set of query sequences against a nucleotide or protein database, then parses the raw BLAST output into VEuPathDB's standard similarity result format. It is used across VEuPathDB's genomic data workflows to generate pairwise sequence similarity data — for example as an input to comparative genomics, orthology, and annotation pipelines. The query FASTA is split into subsets and searched in parallel, and per-subset results are collected into a single output file along with a combined log.

## Requirements

- [Nextflow](https://www.nextflow.io/) (DSL2)
- Docker (the pipeline runs inside the `veupathdb/blastsimilarity` container image; enabled by default in `nextflow.config`)

## Usage

```
nextflow run VEuPathDB/blast-similarity-nextflow -r main \
  --seqFile /path/to/query.fasta \
  --databaseFasta /path/to/target.fasta \
  --databaseType nucl \
  --blastProgram blastn \
  --outputDir /path/to/output \
  -resume
```

The pipeline has a single entry point that branches internally based on `params.preConfiguredDatabase`:

- If `params.preConfiguredDatabase` is `false` (the default), `makeblastdb` builds a new BLAST database from `params.databaseFasta` (of type `params.databaseType`) before running the search.
- If `params.preConfiguredDatabase` is `true`, the search runs directly against an existing BLAST database, given by `params.databaseDir` and `params.databaseBaseName`, skipping the database-build step.

Example using a pre-built database:

```
nextflow run VEuPathDB/blast-similarity-nextflow -r main \
  --seqFile /path/to/query.fasta \
  --preConfiguredDatabase true \
  --databaseDir /path/to/database \
  --databaseBaseName newdb.fasta \
  --blastProgram blastp \
  --outputDir /path/to/output \
  -resume
```

## Key Parameters

| Parameter | Default | Description |
|---|---|---|
| `seqFile` | `data/isosmall.fsa` | FASTA file of query sequences to search |
| `fastaSubsetSize` | `1` | Number of sequences per chunk when splitting the query FASTA for parallel searches |
| `blastProgram` | `blastn` | NCBI BLAST+ program to run (`blastn`, `blastp`, `blastx`, `tblastn`, `tblastx`) |
| `blastArgs` | `""` | Additional raw command-line arguments passed to the BLAST program |
| `preConfiguredDatabase` | `false` | Whether to search against an existing BLAST database instead of building one |
| `databaseFasta` | `data/genomicSeqs.fa` | FASTA file used to build the BLAST database when `preConfiguredDatabase` is `false` |
| `databaseType` | `nucl` | Database type (`nucl` or `prot`) passed to `makeblastdb`, used when `preConfiguredDatabase` is `false` |
| `databaseDir` | `data/database` | Directory containing a pre-built BLAST database, used when `preConfiguredDatabase` is `true` |
| `databaseBaseName` | `newdb.fasta` | Base name of the pre-built database files in `databaseDir` |
| `pValCutoff` | `1e-5` | Minimum p-value/e-value for a hit to be retained |
| `lengthCutoff` | `1` | Minimum alignment length for a hit to be retained |
| `percentCutoff` | `1` | Minimum percent identity for a hit to be retained |
| `outputType` | `both` | Result summarization mode passed to `blastSimilarity.pl`: `sum`, `span`, or `both` |
| `printSimSeqs` | `false` | When `true`, format output with `printSimSeqs.pl` (per-hit similarity summary) instead of `blastSimilarity.pl` |
| `adjustMatchLength` | `false` | Whether to remove masked residues when computing match length/identity stats |
| `dataFile` | `blastSimilarity.out` | Filename of the collected similarity results, written to `outputDir` |
| `logFile` | `blastSimilarity.log` | Filename of the collected run log, written to `outputDir` |
| `outputDir` | `$launchDir/output` | Directory the final output files are published to |

## Output

- `<dataFile>` — collected BLAST similarity results (format depends on `outputType`/`printSimSeqs`), written to `outputDir`
- `<logFile>` — collected log of parsing/filtering messages, written to `outputDir`
