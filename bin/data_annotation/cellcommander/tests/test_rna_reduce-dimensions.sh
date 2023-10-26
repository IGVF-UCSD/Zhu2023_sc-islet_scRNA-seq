outdir_path=/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/annotation/26Oct23/cellbender/H1-D11

cmd="cellcommander reduce-dimensions \
--input_h5ad_path $outdir_path/normalize/sctransform_only.h5ad \
--outdir_path $outdir_path/reduce_dimensions \
--output_prefix scanpy_default_pca \
--method scanpy_default \
--obsm_key sctransform_scale_data"

echo $cmd
eval $cmd
