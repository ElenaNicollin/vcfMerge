from pipeline import *

rule all:
    input:
        "/home/VCF/{ID}.gz.csi", ID=wildcard('/home/VCF/', ['.vcf'])[0])
        "/home/Log/DNA_RNA_merged.vcf"

rule compress:
    input:
        "/home/VCF/{sample}.vcf"
    output:
        "/home/VCF{sample}.vcf.gz
    shell:
        "bgzip -c {input} > {output}"


rule index:
    input:
        "/home/VCF/{sample}.vcf.gz"
    output:
        "/home/VCF/{sample}.vcf.gz.csi"
    wrapper:
        "v1.3.2/bio/bcftools/index"


rule bcftools_merge:
    input:
        calls=["/home/VCF/LMS25R_HaplotypeCaller_filtered.vcf.gz", "/home/VCF/LMS25T.vcf.gz"]
    output:
        "/home/OutputFiles/DNA_RNA_merged.vcf"
    params:
        ""  # optional parameters for bcftools concat (except -o)
    wrapper:
        "0.61.0/bio/bcftools/merge"