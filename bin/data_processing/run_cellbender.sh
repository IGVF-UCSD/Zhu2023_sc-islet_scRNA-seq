cellranger_dir=/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/processed/24Oct23/cellranger
h5_files=($(ls -d $cellranger_dir/*/*/* | grep outs/raw_feature_bc_matrix.h5))
script=/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/bin/data_processing/SLURM_run_cellbender.sh
for h5_file in ${h5_files[@]};
do
    sample=$(echo $h5_file | rev | cut -d "/" -f 3 | rev)
    output_dir=/cellar/users/aklie/data/datasets/Zhu2023_sc-islet_scRNA-seq/processed/25Oct23/cellbender/$sample
    if [ ! -d $output_dir ]; then
        mkdir -p $output_dir
    fi
    cd $output_dir
    cmd="sbatch --job-name=Zhu2023_sc-islet_scRNA-seq_cellbender $script $h5_file $sample $output_dir"
    echo -e $cmd
    eval $cmd
done