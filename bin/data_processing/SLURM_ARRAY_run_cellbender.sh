#!/bin/bash
#SBATCH --account carter-gpu
#SBATCH --partition carter-gpu
#SBATCH --gpus=1
#SBATCH --output=/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/bin/data_processing/slurm_logs/%x.%A_%a.out
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=16G
#SBATCH --time=05:00:00
#SBATCH --array=1-5%5

#####
# USAGE:
# sbatch --job-name=Zhu2023_sc-islet_scRNA-seq_cellbender SLURMARRAY_run_cellbender.sh
#####

# Date
date
echo -e "Job ID: $SLURM_JOB_ID\n"

# Configuring env (choose either singularity or conda)
source activate /cellar/users/aklie/opt/miniconda3/envs/cellbender
LD_LIBRARY_PATH=/cellar/users/aklie/opt/miniconda3/envs/cellbender/lib/python3.7/site-packages/nvidia/cublas/lib:$LD_LIBRART_PATH
echo -e "Checking CUDA availability:"
python -c "import torch; print(torch.cuda.is_available())"

# Get a list of paths to the raw_feature_bc_matrix.h5 files. There are 27 subdirectories in the cellranger directory named igvf_sampleid_deep. Each of these has an outs directory that contains the raw_feature_bc_matrix.h5 file. Do not use find, and it should return all 27 files in an array
cellranger_dir=/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/processed/24Oct23/cellranger
h5_files=($(ls -d $cellranger_dir/*/*/* | grep outs/raw_feature_bc_matrix.h5))
h5_file=${h5_files[$SLURM_ARRAY_TASK_ID-1]}
sample=$(echo $h5_file | rev | cut -d "/" -f 3 | rev)
output_dir=/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/processed/24Oct23/cellbender/$sample
if [ ! -d $output_dir ]; then
    mkdir -p $output_dir
else
    echo -e "Output directory $output_dir already exists. Skipping."
    #exit 1
fi

# Run cellbender
cmd="cellbender remove-background --input $h5_file --output $output_dir/cellbender_raw_feature_bc_matrix.h5 --cuda >> $output_dir/cellbender.out 2> $output_dir/cellbender.err"
echo -e $cmd
eval $cmd

# Date
date
