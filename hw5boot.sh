#!/bin/bash -l

# Give the job a name
#SBATCH --job-name bootstrap

# Setting the number of CPUs per task
#SBATCH --cpus-per-task=2

Rscript ./STA-141C/hw5bootstrap.R
