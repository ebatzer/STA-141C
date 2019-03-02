#!/bin/bash -l

# Give the job a name
#SBATCH --job-name bootstrap

Rscript ./STA-141C/hw5bootstrap.R
