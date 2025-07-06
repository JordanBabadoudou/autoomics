params.reads = ''
params.transcriptome = ''

workflow {
    Channel
        .fromPath(params.reads)
        .set {read_files}

    process cellranger_count {
        input:
            path reads from read_files
        output:
            path 'outs/filtered_feature_bc_matrix/'
        script:
            """
            cellranger count --id=sample \\
                            --transcriptome=${params.genome} \\
                            --fastqs = ${reads} \\
            """
    }
}