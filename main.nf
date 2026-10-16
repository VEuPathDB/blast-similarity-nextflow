#!/usr/bin/env nextflow
nextflow.enable.dsl=2


//--------------------------------------------------------------------------
// Includes
//--------------------------------------------------------------------------

include { nonConfiguredDatabase } from './modules/blastSimilarity.nf'
include { preConfiguredDatabase } from './modules/blastSimilarity.nf'


//--------------------------------------------------------------------------
// Main Workflow
//--------------------------------------------------------------------------

workflow {
  if(!params.fastaSubsetSize) {
    error "Missing params.fastaSubsetSize"
  }

  if(params.seqFile) {
    seqs = channel.fromPath( params.seqFile )
             .splitFasta( by:params.fastaSubsetSize, file:true  )
  }
  else {
    error "Missing params.seqFile"
  }

  if (params.preConfiguredDatabase) {
    if (!params.databaseDir) {
      error "Missing params.databaseDir"
    }
    else if(!params.databaseBaseName) {
      error "Missing params.databaseBaseName"
    }
  }
  
  if (!params.preConfiguredDatabase) {
    nonConfiguredDatabase(seqs)
  }
   
  else if (params.preConfiguredDatabase) {
    preConfiguredDatabase(seqs)
  }

}

