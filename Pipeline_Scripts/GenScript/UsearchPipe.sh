#!/bin/bash

#vars4 = sample list 
echo "************************************************** Running Unoise3 Pipeline *************************************************"

echo "Reading in " $1

readarray -t vars <$1

if [ ${vars[0]} -eq 1]; then
    echo "Removing old data"
    rm -rf ../../../DenoiseCompare_Out/${vars[1]}/$2/Unoise
fi


cd ../../../DenoiseCompare_Out/${vars[1]}/$2/

mkdir Unoise

cd Unoise

pwd

echo "***********************************Pooling Samples Together ***********************************"
for Sample in ${vars[4]}
do
    usearch10 -fastq_mergepairs ../filtered_fastqs/${Sample}*_R1*.fastq -fastqout $Sample.merged.fq -relabel $Sample.
    cat $Sample.merged.fq >> all.merged.fq
done


source activate qiime1

echo "********************************** Convert to FASTA ****************************************"
run_fastq_to_fasta.pl -p ${vars[3]} -o fasta_files all.merged.fq

echo "************************************* Finding Unique Reads and Abundances ***********************"
usearch10 -fastx_uniques fasta_files/*fasta -sizeout -relabel Uniq -fastaout uniques.fa

echo "******************************** DeNoise Sequences ****************************************************************"
usearch10 -unoise3 uniques.fa -zotus zotus.fa

cp zotus.fa zotusfix.fa

#change zotu label to otu ---> bug in usearch10
#some reason causes biom file to not be recognized by biom .... need to figure out whats going on here.
sed -i -e 's/Zotu/Otu/g' zotus.fa

echo "******************************************* Making Otu Tables *****************************************************"
usearch10 -otutab all.merged.fq -zotus zotus.fa -biomout otutab.biom -mapout map.txt -otutabout otutab.txt

echo "********************************************* Rarify OTU Table ******************************************************"
biom summarize-table -i otutab.biom -o seqtab_summary.txt

rare="$(cat seqtab_summary.txt | awk 'NR >= 16 { print }' | awk -F" " '{print $2}' | head -1)"
rarefix=${rare/.0/}
single_rarefaction.py -i otutab.biom -o seqtab_rare.biom -d $rarefix
