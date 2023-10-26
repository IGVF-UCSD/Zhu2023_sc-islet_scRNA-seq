#!/bin/bash
#SBATCH --account carter-gpu
#SBATCH --partition carter-gpu
#SBATCH --gpus=1
#SBATCH --output=/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/bin/data_processing/slurm_logs/%x.%A.out
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=32G
#SBATCH --time=05:00:00

#####
# USAGE:
# sbatch --job-name=Zhu2023_sc-islet_scRNA-seq_cellbender SLURM_run_cellbender.sh /path/to/h5_file sample /path/to/output_dir
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
h5_file=$1

# Run cellbender
cmd="cellbender remove-background --input $h5_file --output cellbender_raw_feature_bc_matrix.h5 --cuda >> cellbender.out 2> cellbender.err"
echo -e $cmd
eval $cmd

# Date
date
