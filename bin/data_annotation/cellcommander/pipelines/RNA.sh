#!/bin/bash
#SBATCH --partition=carter-compute
#SBATCH --output=/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/bin/data_annotation/cellcommander/slurm_logs/%x.%A_%a.out
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=32G
#SBATCH --time=14:00:00
#SBATCH --array=1-5%5

#####
# USAGE:
# sbatch --job-name=Zhu2023_sc-islet_scRNA-seq_pipeline RNA.sh
#####

# Date
date
echo -e "Job ID: $SLURM_JOB_ID\n"

# Configuring env (choose either singularity or conda)
source activate /cellar/users/aklie/opt/miniconda3/envs/cellcommander

indir_paths=(
    '/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/processed/25Oct23/cellbender/H1-D11'
    '/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/processed/25Oct23/cellbender/H1-D14'
    '/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/processed/25Oct23/cellbender/H1-D21'
    '/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/processed/25Oct23/cellbender/H1-D32'
    '/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/processed/25Oct23/cellbender/H1-D39'
)
sample_ids=(
    'H1-D11'
    'H1-D14'
    'H1-D21'
    'H1-D32'
    'H1-D39'
)
indir_path=${indir_paths[$SLURM_ARRAY_TASK_ID-1]}
sample_id=${sample_ids[$SLURM_ARRAY_TASK_ID-1]}
outdir_path=/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/annotation/26Oct23/cellcommander/${sample_id}

# If output dir does not exist, create it
if [ ! -d $outdir_path ]; then
    mkdir -p $outdir_path
fi

# Step 1 -- QC and filtering
echo -e "Running step 1 -- QC and filtering in two modes\n"
cmd="cellcommander qc \
--input_h5_path $indir_path/cellbender_raw_feature_bc_matrix_filtered.h5 \
--outdir_path $outdir_path/mad_qc \
--output_prefix mad_qc \
--mode rna \
--filtering_strategy mad \
--total_counts_nmads 2 \
--n_features_nmads 2 \
--pct_counts_mt_hi 10 \
--random-state 1234"
echo -e "Running:\n $cmd\n"
eval $cmd

cmd="cellcommander qc \
--input_h5_path $indir_path/cellbender_raw_feature_bc_matrix_filtered.h5 \
--outdir_path $outdir_path/threshold_qc \
--output_prefix threshold_qc \
--mode rna \
--filtering_strategy threshold \
--n_features_low 1000 \
--n_features_hi 8000 \
--pct_counts_mt_hi 10 \
--random-state 1234"
echo -e "Running:\n $cmd\n"
eval $cmd
echo -e "Done with step 1\n"

# Step 2 -- Detect doublets
echo -e "Running step 2 -- Detect doublets\n"
cmd="cellcommander detect-doublets \
--input_h5ad_path $outdir_path/threshold_qc/threshold_qc.h5ad \
--outdir_path $outdir_path/detect_doublets \
--output_prefix scrublet_only \
--method scrublet \
--random-state 1234"
echo -e "Running:\n $cmd\n"
eval $cmd
echo -e "Done with step 2\n"

# Step 3 -- Normalize data
echo -e "Running step 3 -- Normalize data\n"
cmd="cellcommander normalize \
--input_h5ad_path $outdir_path/detect_doublets/scrublet_only.h5ad \
--outdir_path $outdir_path/normalize \
--output_prefix sctransform_only \
--save-normalized-mtx \
--methods sctransform \
--random-state 1234"
echo -e "Running:\n $cmd\n"
eval $cmd
echo -e "Done with step 3\n"

# Step 4 -- Reduce dimensionality
echo -e "Running step 4 -- Reduce dimensionality\n"
cmd="cellcommander reduce-dimensions \
--input_h5ad_path $outdir_path/normalize/sctransform_only.h5ad \
--outdir_path $outdir_path/reduce_dimensions \
--output_prefix scanpy_default_pca \
--method scanpy_default \
--obsm_key sctransform_scale_data \
--random-state 1234"
echo -e "Running:\n $cmd\n"
eval $cmd
echo -e "Done with step 4\n"

date
