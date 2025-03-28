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
      cut -d',' -f1 | grep -E "^SRR|^ERR" | grep -v "ERR3440669" >> "$OUTPUT_SRR_LIST"
  done

# Download the reads 
# need to sudo because raw_seq_data is owned by root
# If I specify a single output directory is it going to overwrite it?
sudo prefetch --option-file all_srr_ids.txt --max-size 100G -p -O /raw_seq_data/Julin-FERN/sra

cat all_srr_ids.txt | xargs -n 1 -P 4 fasterq-dump --split-files --gzip --outdir ./fastq_files



