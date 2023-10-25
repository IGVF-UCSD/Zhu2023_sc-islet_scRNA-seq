#!/bin/bash
#SBATCH --partition=carter-compute
#SBATCH --output=/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/bin/data_processing/slurm_logs/%x.%A_%a.out
#SBATCH --error=/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/bin/data_processing/slurm_logs/%x.%A_%a.err
#SBATCH --cpus-per-task=16
#SBATCH --mem=36G
#SBATCH --time=02-00:00:00
#SBATCH --array=1-5%5

#####
# USAGE:
# sbatch --job-name=Zhu2023_sc-islet_scRNA-seq_run_kb-count SLURM_ARRAY_run_kb-count.sh
#####

# Start time
date
echo -e "Job ID: $SLURM_JOB_ID\n"

# Activate the env with kb python package
source activate /cellar/users/aklie/opt/miniconda3/envs/pipelines

# Set file paths
fastq_dir=/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/fastq/24Oct23/SRP374217
output_dir=/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/processed/24Oct23/kb_count
ref_dir=/cellar/users/aklie/data/ref/genomes/hg38/kb_ref
bc_whitelist=/cellar/users/aklie/data/ref/bc_whitelists/737K-cratac-v1.rc.txt

# Samples
experiment_accessions=(
    'SRX15207309'
    'SRX15207310'
    'SRX15207311'
    'SRX15207312'
    'SRX15207313'
)
sample_ids=(
    'H1-D11'
    'H1-D14'
    'H1-D21'
    'H1-D32'
    'H1-D39'
)
input_dir=$fastq_dir/${experiment_accessions[$SLURM_ARRAY_TASK_ID-1]}
sample=${sample_ids[$SLURM_ARRAY_TASK_ID-1]}
read1=$(ls $input_dir/*_R1*.fastq.gz)
read2=$(ls $input_dir/*_R2*.fastq.gz)

# Make output directory if doesn't exist
if [ ! -d $output_dir/$sample ]; then
    mkdir -p $output_dir/$sample
fi

# Run the command
cmd="kb count \
-i $ref_dir/index.idx \
-g $ref_dir/t2g.txt \
-x 10xv3 \
-w $bc_whitelist \
-o $output_dir/$sample \
-t 12 \
-m 32G \
--h5ad \
$read1 $read2"

echo -e "Running:\n $cmd\n"
eval $cmd

# End time
date
