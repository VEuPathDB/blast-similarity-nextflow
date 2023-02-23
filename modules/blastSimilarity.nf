#!/usr/bin/env nextflow
nextflow.enable.dsl=2


process createDatabase {
  input:
    path newdbfasta

  output:
    path 'newdb.fasta.*'

  script:
    template 'createDatabase.bash'
}


process blastSimilarity {
  input:
    val fastaName
    path subsetFasta
    path blastDatabase
    val pValCutoff 
    val lengthCutoff 
    val percentCutoff 
    val blastProgram  
    val blastArgs 
    val doNotParse 
    val printSimSeqsFile 
    val saveAllBlastFiles
    val saveGoodBlastFiles
    val adjustMatchLength


  output:
    path 'blastSimilarity.out', emit: output_file
    path 'blastSimilarity.log', emit: log_file
    path '*.gz*', optional: true, emit: zip_files

  script:
    template 'blastSimilarity.bash'
}


workflow nonConfiguredDatabase {
  take:
    seqs

  main:
    database = createDatabase(params.databaseFasta)
    blastSimilarityResults = blastSimilarity("newdb.fasta", seqs, database, params.pValCutoff, params.lengthCutoff, params.percentCutoff, params.blastProgram, params.blastArgs, params.doNotParse, params.printSimSeqsFile, params.saveAllBlastFiles, params.saveGoodBlastFiles, params.adjustMatchLength)
    blastSimilarityResults.output_file | collectFile(storeDir: params.outputDir, name: params.dataFile)
    blastSimilarityResults.log_file | collectFile(storeDir: params.outputDir, name: params.logFile)
    blastSimilarityResults.zip_files | collectFile(storeDir: params.outputDir)
}


workflow preConfiguredDatabase {
  take:
    seqs

  main:
    database = file(params.databaseDir + "/*")
    blastSimilarityResults = blastSimilarity(params.databaseBaseName, seqs, database, params.pValCutoff, params.lengthCutoff, params.percentCutoff, params.blastProgram, params.blastArgs, params.doNotParse, params.printSimSeqsFile, params.saveAllBlastFiles, params.saveGoodBlastFiles, params.adjustMatchLength)
    blastSimilarityResults.output_file | collectFile(storeDir: params.outputDir, name: params.dataFile)
    blastSimilarityResults.log_file | collectFile(storeDir: params.outputDir, name: params.logFile)
    blastSimilarityResults.zip_files | collectFile(storeDir: params.outputDir)
    
}