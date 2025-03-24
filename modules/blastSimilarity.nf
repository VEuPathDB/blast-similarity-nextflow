#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process createDatabase {
  container = 'veupathdb/blastsimilarity:v1.0.0'

  input:
    path newdbfasta

  output:
    path 'newdb.fasta.*'

  script:
    template 'createDatabase.bash'
}

process blastSimilarity {
  container = 'veupathdb/blastsimilarity:v1.0.0'

  input:
    val databaseName
    path subsetFasta
    path blastDatabase
    val pValCutoff 
    val lengthCutoff 
    val percentCutoff 
    val blastProgram  
    val blastArgs 
    val outputType 
    val printSimSeqs 
    val adjustMatchLength

  output:
    path 'blastSimilarity.out', emit: output_file
    path 'blastSimilarity.log', emit: log_file

  script:
    template 'blastSimilarity.bash'
}


workflow nonConfiguredDatabase {
  take:
    seqs

  main:
    database = createDatabase(params.databaseFasta)
    blastSimilarityResults = blastSimilarity("newdb.fasta", seqs, database, params.pValCutoff, params.lengthCutoff, params.percentCutoff, params.blastProgram, params.blastArgs, params.outputType, params.printSimSeqs, params.adjustMatchLength)
    blastSimilarityResults.output_file | collectFile(storeDir: params.outputDir, name: params.dataFile)
    blastSimilarityResults.log_file | collectFile(storeDir: params.outputDir, name: params.logFile)
}


workflow preConfiguredDatabase {
  take:
    seqs

  main:
    database = file(params.databaseDir + "/*")
    blastSimilarityResults = blastSimilarity(params.databaseBaseName, seqs, database, params.pValCutoff, params.lengthCutoff, params.percentCutoff, params.blastProgram, params.blastArgs, params.outputType, params.printSimSeqs, params.adjustMatchLength)
    blastSimilarityResults.output_file | collectFile(storeDir: params.outputDir, name: params.dataFile)
    blastSimilarityResults.log_file | collectFile(storeDir: params.outputDir, name: params.logFile)
}