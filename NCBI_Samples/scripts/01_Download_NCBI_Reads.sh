## Script to download C. richardii RNAseq reads from the NCBI SRA
## Julin Maloof
## March 28, 2025

## I first went to bioproject and searched for "Ceratopteris richardii"

## The results were downloaded and then editted to remove
## Other organisms and DNA reads.
## The editted table is in ../input/biprojectlist.csv

## Install edirect
sh -c "$(curl -fsSL https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh)"
export PATH=${PATH}:${HOME}/edirect

## Install sra-toolkit
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.2.1/setup-apt.sh
chmod u+x setup-apt.sh
./setup-apt.sh
source /etc/profile.d/sra-tools.sh

## Now get the Reads

# Create a file with just the bioproject accessions:
cd ../input

cut -f 1 -d "," bioprojectlist.csv | grep "#" -v  > bioproject_accessions.txt

# Get the run info:
OUTPUT_SRR_LIST="all_srr_ids.txt"

> "$OUTPUT_SRR_LIST" # Clears existing file or creates a new one

for bioproject in $(cat bioproject_accessions.txt)
  do
    echo $bioproject
      esearch -db sra -query "$bioproject" | efetch -format runinfo | \
      cut -d',' -f1 | grep -E "^SRR|^ERR" | grep -vE "ERR3440669|SRR12605705|SRR12605702|SRR9829640|SRR12605706|SRR12605704|SRR513505|SRR513506|SRR513501" >> "$OUTPUT_SRR_LIST"
  done
# ERR3440669 is a microbial read set that I think mistakingly got added to a fern bioproject.  The others are wrong platform or too large.

# Download the reads 
prefetch --option-file all_srr_ids.txt --max-size 100G -p -O /analyzed_data/Julin/sequencing/Julin-FERN/ncbi/prefetch

cd /analyzed_data/Julin/sequencing/Julin-FERN/ncbi

# Note, could increase P to > 1 if on machine with a lot of cpus, but fasterq-dump is already mulithreaded (Default 6)
# Note: originally I had gzip following the fasterq-dump in the same command but that is slow.  Better to do them separately to better be able to take advantage of multiprocessors for gzip
cat  ~/git/McConnell-Ceratopteris-RNAseq/NCBI_Samples/input/all_srr_ids.txt | xargs -L 1 -P 1 -I {} fasterq-dump ./prefetch/{} --split-3 --outdir /media/volume/julin-scratch/fastqs 
cd /media/volume/julin-scratch/fastqs 

ls -1 | xargs -L 1 -P 4  gzip 




