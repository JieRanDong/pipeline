# make sure meme has been installed
conda activate meme

# download jaspar PFMs(MEME type)
mkdir jaspar; cd jaspar
wget https://jaspar.elixir.no/download/data/2026/CORE/JASPAR2026_CORE_non-redundant_pfms_meme.zip
unzip JASPAR2026_CORE_non-redundant_pfms_meme.zip
rm JASPAR2026_CORE_non-redundant_pfms_meme.zip

# JASPAR file process
sh process.sh
cat jaspar/* > jaspar_PFMs.meme

# analysis
PATH=$(pwd)
for id in segment_1 segment_2
	do
		cd $id
		fimo --thresh 1e-4 ../jaspar_PFMs.meme ${id}.fa
		cd $PATH
done
