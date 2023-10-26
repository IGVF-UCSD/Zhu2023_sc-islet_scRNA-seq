input_h5_path=/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/processed/25Oct23/cellcommander/H1-D11/cellbender_raw_feature_bc_matrix_filtered.h5
outdir_path=/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/annotation/26Oct23/cellcommander/H1-D11

cmd="cellcommander qc \
--input_h5_path $input_h5_path \
--outdir_path $outdir_path/mad_qc \
--output_prefix mad_qc \
--mode rna \
--filtering_strategy mad \
--total_counts_nmads 2 \
--n_features_nmads 2 \
--pct_counts_mt_hi 10 \
--random-state 1234"

echo $cmd
eval $cmd

cmd="cellcommander qc \
--input_h5_path $input_h5_path \
--outdir_path $outdir_path/threshold_qc \
--output_prefix threshold_qc \
--mode rna \
--filtering_strategy threshold \
--n_features_low 1000 \
--n_features_hi 8000 \
--pct_counts_mt_hi 10 \
--random-state 1234"

echo $cmd
eval $cmd
