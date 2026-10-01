#!/bin/bash
#SBATCH --job-name=H5_to_COOL_script
#SBATCH --output=H5_to_COOL_script.out
#SBATCH --error=H5_to_COOL_script.err
#SBATCH --time=72:00:00
#SBATCH --cpus-per-task=30
#SBATCH --mem=64G
#SBATCH --partition=biosoc2

# Converts a H5 file into a COOL file

hicConvertFormat --matrices {normalized_corrected.h5} --outFileName {output_1Kb.cool}  --inputFormat h5 --outputFormat cool
