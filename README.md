This project allows a user to create a container for Rscipt with the CmdStanR library, and use that container in batch jobs launched by the Slurm scheduler and executed on the Expanse cluster at SDSC. The batch script assumes the use of Singularity, but a container definition for Docker is also included. The batch script has a line near the top
 
#SBATCH -A \<\<project\>\>
 
that designates the project that will be charged for a job run using this script. You’ll need to replace the \<\<project\>\> part with the appropriate project code. Another couple of lines near the top
 
#SBATCH --ntasks-per-node=16
#SBATCH --mem=32G
 
indicate how many cores and how much memory the job will request. In development, I used an R script that allocated 4 parallel chains and a Stan model that didn’t use any threaded functions. Because of this, a job using this script will only utilize 4 of the 16 cores requested. I found, however, that the job runs fastest when each chain has at least 8GB of memory to work with. On Expanse, each compute node has 128 cores and 256GB of memory, so those resources are effectively allocated in 1 core and 2GB increments, regardless of whether or not your request aligns with that ratio. So, asking for 32GB of memory is effectively also asking for 16 cores. To submit the job to the scheduler, you would use the sbatch command, as follows:
 
sbatch rscript_job.sh
 
The scheduler will send you email updates when the job actually starts execution, and when it finishes or fails. You can check on the status of all jobs in your queue by running
 
squeue -u $USER
 
Any output from the job can be found in the directory
 
/expanse/lustre/scratch/$USER/temp_project/job-\<\<job ID\>\>
 
where \<\<job ID\>\> is the numeric identity assigned to the job by the scheduler.
