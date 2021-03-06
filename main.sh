pwd1=$(pwd)
cd ~/Downloads
#install tensorFlow
sudo apt-get install python3-pip python3-dev python-virtualenv
virtualenv --system-site-packages -p python3  tensorflow
pip3 install --upgrade tensorflow
source ~/Downloads/tensorflow/bin/activate 

#install Keras
cd ~/Downloads
 virtualenv --system-site-packages -p python3 keras_tf
 source ~/Downloads/keras_tf
 pip3 install numpy scipy
 pip3 install scikit-learn
 pip3 install pillow
 pip3 install h5py
 pip3 install keras
 
#install jellyFish
cd ~/Downloads
sudo apt-get update
sudo apt-get install jellyfish

#Get The Dataset file
cd $(pwd)
mkdir -p $(pwd)/DataSet
cd $(pwd)/DataSet
wget -O GSE20592_RAW.tar 'https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE20592&format=file' 

#unzip tar file
#gzip  GSE20592_RAW.tar
tar -xvf GSE20592_RAW.tar

#unzip all files
gunzip *.gz

#convert text files to fasta files
python $(pwd)/Scripts/ConvertToFasta.py

#Cluster Data to N and T
mkdir -p $(pwd)/N
mkdir -p $(pwd)/T
python $(pwd)/Scripts/ClusterData.py

#catch kmers
cd $(pwd)/DataSet
for n in *.fasta; do 
#printf '%s\n' "$n";
jellyfish count -m 21 -s 100M -t 10 -C  $n;
jellyfish dump mer_counts.jf > ${n%.*}.fa;
done

#repeate each kmer by its frequency
python $(pwd)/Scripts/repeatKmers.py

python $(pwd)/Scripts/MergeNormalData.py

python $(pwd)/Scripts/MergeTumerData.py

python $(pwd)/Scripts/MergeAllFiles

