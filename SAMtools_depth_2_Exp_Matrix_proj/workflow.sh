mkdir -p mean/expression

samtools index *bam

for bam in Parental_1 Parental_2 Resistant_1 Resistant_2
	do for bed in p1 p2
		do
		cat ${bed}.bed | while read chr start end name
			# -q 0 -Q 0 --excl-flags 0 关闭碱基质量过滤、比对质量过滤、FLAG 过滤，保留未配对、次比对、补充比对
			do samtools depth -a -r ${chr}:${start}-${end} ../bam/${bam}.clean.uniq.rmdup.bam  > ${bed}_${name}_${bam}.txt
			done
		done
done

ls *txt | while read id; do awk '{sum+=$3; count++} END {print sum/count}' $id > mean/mean_${id}.txt ; done

for group in Parental_1 Parental_2 Resistant_1 Resistant_2
	do
		printf ""${group}"\n">expression/expression_${group}.txt
		ls *${group}* | sort | while read id
			do
				cat ${id} >> expression/expression_${group}.txt
		done
done

ls *Parental_1* | sort | while read id
	do echo $id | cut -d'_' -f2-3 >> expression/rownames.txt
done
sed -i '1i TF' expression/rownames.txt

cd expression

paste rownames.txt expression_Parental_1.txt expression_Parental_2.txt expression_Resistant_1.txt expression_Resistant_2.txt > expression_matrix.txt