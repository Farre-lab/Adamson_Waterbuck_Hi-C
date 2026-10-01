#!/bin/bash
#SBATCH --job-name=Hi-C_Varaint_Calling_EagleC2
#SBATCH --output=Hi-C_Varaint_Calling_EagleC2.out
#SBATCH --error=Hi-C_Varaint_Calling_EagleC2.err
#SBATCH --time=72:00:00
#SBATCH --cpus-per-task=30
#SBATCH --mem=64G
#SBATCH --partition=biosoc2

# This script detects Hi-C structural variants 
# The --prob-cutoff-1 and -2 values select the minium probability score for the structural variants called 
# The probablility score is used as an indication of how confident to be in the structural varaint
# Balance type ICE is used when the mcool file has been balanced with cooler balance

# input file: {output.mcool}

# Ouputs two files:
# output file 1: file_name.SV_calls.txt
# output file 2: file_name.log

predictSV --mcool {output.mcool} --resolutions 50000,100000,250000,500000 --prob-cutoff-1 0.3 --prob-cutoff-2 0.3 -O {file_name} -g other --balance-type ICE -p 8 --intra-extend-size 1,1,1,1 --inter-extend-size 1,1,1,1
