import sys
sys.path.append('/home/Utils/')
from pipeline import *

rule all:
    input:
        expand("/home/VCF/{ID}.vcf.gz.csi", ID=wildcard('/home/VCF/', ['.vcf'])[0]),
        "/home/OutputFiles/DNA_RNA_merged.vcf"

rule bgzip_compress:
    input:
        "/home/VCF/{sample}.vcf"
    output:
        "/home/VCF/{sample}.vcf.gz"
    shell:
        "bgzip -c {input} > {output}"


rule bcftools_index:
    input:
        "/home/VCF/{sample}.vcf.gz"
    output:
        "/home/VCF/{sample}.vcf.gz.csi"
    wrapper:
        "v1.3.2/bio/bcftools/index"


rule bcftools_merge:
    input:
        calls=expand("/home/VCF/{ID}.vcf.gz", ID=wildcard('/home/VCF/',['.vcf'])[0])
    output:
        "/home/OutputFiles/DNA_RNA_merged.vcf"
    params:
        ""  # optional parameters for bcftools concat (except -o)
    wrapper:
        "0.61.0/bio/bcftools/merge"