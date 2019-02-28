#!/bin/bash -l

# Use the staclass partition. Only applies if you are in STA141C
#SBATCH --partition staclass

# Give the job a name
#SBATCH --job-name hwsub

module load python3

bash ./STA-141C/hw5shell.sh
