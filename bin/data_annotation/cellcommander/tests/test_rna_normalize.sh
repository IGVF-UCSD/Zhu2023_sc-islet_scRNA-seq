outdir_path=/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/annotation/26Oct23/cellbender/H1-D11

cmd="cellcommander normalize \
--input_h5ad_path $outdir_path/detect_doublets/scrublet_only.h5ad \
--outdir_path $outdir_path/normalize \
--output_prefix sctransform_only \
--save-normalized-mtx \
--methods sctransform"

echo $cmd
eval $cmd
