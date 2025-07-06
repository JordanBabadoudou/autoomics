params.read = ''
params.genomeDir = ''
params.gtf = ''
params.threads = 4

workflow{

    Channel
        .fromPath(params.read)
        .ifEmpty { error 'Aucun fichier FASTQ trouvé: ${params.read}'}
        .set { fastq_files }

    process trim_reads {
        input:
            path fq from fastq_files
        output:
            path 'trimmed.fastq.gz' into trimmed_reads
        script:
            """
            fastp -i ${fq} -o trimmed.fastq.gz
            """
    }

    process align_reads{
        input:
            path fq from trimmed_reads
        output:
            path 'Aligned.out.bam' into bam_files
        script:
            """
            STAR --runThread ${params.threads} \\
                 --genomeDir ${params.genomeDir} \\
                 --readFilesIn ${fq} \\
                 --outFileNamePrefix Aligned. \\
                 --outSamtype Bam Unsorted
            """
    }

    process count_genes {
        input:
            path bam from bam_files
        output:
            path 'counts.txt'
        script:
            """
            featureCounts -a ${params.gtf} -o counts.txt ${bam}
            """
    }
}