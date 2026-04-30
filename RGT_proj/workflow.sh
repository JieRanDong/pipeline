# ======================== Step 1 ============================
# handle genome files

cd ~/rgtdata
nohup python setupGenomicData.py --hg38 > setupGenomicData.log 2>&1 &

# keep the name of genome.fa and chrom.size as same
awk -F '\t' '{print $1}' id_trans.txt > id.txt
seqkit grep -n -f id.txt genome_hg38.fa > genome_hg38_grep.fa
mv genome_hg38.fa genome_hg38.fa.backup
seqkit replace -k id_trans.txt -p "(.*)" -r "{kv}" genome_hg38_grep.fa -o genome_hg38.fa
samtools faidx genome_hg38.fa

# ======================== Step 2 ============================
# handle input files

cd ~/wkdir
mkdir footprint DEG

# generate merged bam and narrowPeak files
# make sure bam have been sorted
for id in resistant parental
	do
		samtools merge -@ 12 -f ${id}.bam bam/${id}_1.clean.uniq.rmdup.bam bam/${id}_2.clean.uniq.rmdup.bam
		
		cat peak/${id}_1_peaks.narrowPeak peak/${id}_2_peaks.narrowPeak | sort -k1,1 -k2,2n | uniq > ${id}.narrowPeak
done

# Re-confirm whether the chromid of bam and peak is consistent with that in genome.fa
for id in resistant parental
	do
		cp ${id}.bam ${id}.bam.backup
		samtools view -H ${id}.bam | sed -f mapping.sed > ${id}.sam
		samtools reheader ${id}.sam ${id}.bam > ${id}_renamed.bam
		samtools index ${id}_renamed.bam
		
		sed -f mapping.sed ${id}.narrowPeak > ${id}_rename.narrowPeak
done

# ======================== Step 3 ============================
# analysis

# footprint
for id in resistant parental
	do
		nohup rgt-hint footprinting --atac-seq --paired-end --organism=hg38 --output-location=./footprint --output-prefix=${id} ${id}_renamed.bam ${id}_rename.narrowPeak > ${id}_hint.log 2>&1 &
		
		nohup rgt-hint tracks --bc --bigWig --organism=hg38 ${id}_renamed.bam ${id}_rename.narrowPeak --output-location=./footprint --output-prefix=${id} &
done

# motif finding
# input the bed files after footprint
rgt-motifanalysis matching --organism=hg38 --output-location=./footprint --input-files footprint/parental.bed footprint/resistant.bed  

# differential motif finding
# input the bed files after motif finding
nohup rgt-hint differential --organism=hg38 --bc --nc 12 --mpbs-files=footprint/resistant_mpbs.bed,footprint/parental_mpbs.bed --reads-files=resistant_renamed.bam,parental_renamed.bam --conditions=resistant,parental --output-location=./DEG > final.log 2>&1 &
