outdir_path=/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/annotation/26Oct23/cellbender/H1-D11

cmd="cellcommander detect-doublets \
--input_h5ad_path $outdir_path/threshold_qc/threshold_qc.h5ad \
--outdir_path $outdir_path/detect_doublets \
--output_prefix scrublet_only \
--method scrublet"

echo $cmd
eval $cmd
