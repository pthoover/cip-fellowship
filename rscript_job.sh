#!/bin/bash
#SBATCH --job-name="some-model"
#SBATCH -p shared
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --mem=32G
#SBATCH -t 48:00:00
#SBATCH -A <<project>>
#SBATCH -o slurm.%j.%N.out
#SBATCH -e slurm.%j.%N.err
#SBATCH --export=ALL
#SBATCH --mail-type=ALL

module purge
module load singularitypro

job_dir=/expanse/lustre/scratch/$USER/temp_project/job-$SLURM_JOB_ID

mkdir $job_dir
cp run_some_model.r some_model.stan some_data.csv $job_dir

singularity exec --bind $job_dir:/home/work --pwd /home/work --cleanenv --writable-tmpfs cmdstanr.sif entrypoint some_model.r 1>$job_dir/stdout.txt 2>$job_dir/stderr.txt
