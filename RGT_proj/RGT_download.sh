# Official document
# https://reg-gen.readthedocs.io/en/latest/rgt/installation.html

# enviroment preparation
conda create -n rgt python=3.8
conda activate rgt

# software preparation
pip install setuptools==64.0.3
pip install numpy==1.24.4
pip install cython scipy
conda install -c https://mirrors.ustc.edu.cn/anaconda/cloud/conda-forge/ hmmlearn
mamba install bioconda::ucsc-wigtobigwig

# RGT downloading
pip install RGT