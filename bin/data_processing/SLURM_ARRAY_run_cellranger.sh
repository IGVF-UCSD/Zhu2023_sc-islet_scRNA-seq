#!/bin/bash
#SBATCH --partition=carter-compute
#SBATCH --output=/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/bin/data_processing/slurm_logs/%x.%A_%a.out
#SBATCH --error=/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/bin/data_processing/slurm_logs/%x.%A_%a.err
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=14:00:00
#SBATCH --array=1-5%5

#####
# USAGE:
# sbatch --job-name=Zhu2023_sc-islet_scRNA-seq_run_cellranger SLURM_ARRAY_run_cellranger.sh
#####

# Start time
date
echo -e "Job ID: $SLURM_JOB_ID\n"

# Env
source /cellar/users/aklie/.bashrc

# Set file paths
fastq_dir=/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/fastq/24Oct23/SRP374217
output_dir=/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/processed/24Oct23/cellranger

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

# Make output directory if doesn't exist
if [ ! -d $output_dir ]; then
    mkdir -p $output_dir
fi

# Go to output directory
cd $output_dir

# Run the command
cmd="cellranger count \
--id=$sample \
--transcriptome=/cellar/users/aklie/opt/refdata-gex-GRCh38-2020-A \
--fastqs=$input_dir \
--localcores=12 \
--localmem=64"
echo -e "Running:\n $cmd\n"
eval $cmd

# End time
date
