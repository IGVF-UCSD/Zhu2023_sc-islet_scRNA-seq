#! /bin/bash
#SBATCH --partition=carter-compute
#SBATCH --output=/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/bin/data_acquisition/slurm_logs/%x.%A.out
#SBATCH --error=/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/bin/data_acquisition/slurm_logs/%x.%A.err
#SBATCH --mem=100G
#SBATCH -n 64
#SBATCH -t 14-00:00:00

# USAGE: sbatch --job-name=Zhu2023_sc-islet_scRNA-seq_sra_download 1_sra_download.sh

source activate /cellar/users/aklie/opt/miniconda3/envs/get_data
python 1_sra_download.py
