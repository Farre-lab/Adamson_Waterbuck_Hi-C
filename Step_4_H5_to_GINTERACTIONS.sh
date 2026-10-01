#!/bin/bash
#SBATCH --job-name=H5_to_GINTERACTIONS_script
#SBATCH --output=H5_to_GINTERACTIONS_script.out
#SBATCH --error=H5_to_GINTERACTIONS_script.err
#SBATCH --time=72:00:00
#SBATCH --cpus-per-task=30
#SBATCH --mem=64G
#SBATCH --partition=biosoc2

# Converts a H5 file into a GINTERACTIONS file with hicConvertFormat

# input file: {normalised_corrected.h5}
# output file: {output_500kb_ginteractions.tsv}

hicConvertFormat --matrices {normalized_corrected.h5} --outFileName {output_500Kb.ginteractions.tsv}  --inputFormat h5 --outputFormat ginteractions
