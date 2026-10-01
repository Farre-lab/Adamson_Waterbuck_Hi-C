#!/bin/bash
#SBATCH --job-name=1kb_COOL_to_MCOOL_script
#SBATCH --output=1kb_COOL_to_MCOOL_script.out
#SBATCH --error=1kb_COOL_to_MCOOL_script.err
#SBATCH --time=72:00:00
#SBATCH --cpus-per-task=30
#SBATCH --mem=64G
#SBATCH --partition=biosoc2

# cooler zoomify - avaliabe within Cooler conda environment

# input file: {output_1kb.cook}
# output file: {output.mcool}

# Converts a mcool file (a cool file of multiple resolutions - specifically containing the listed resolutions (--resolutions)

cooler zoomify {output_1kb.cool} --resolutions 1000,5000,10000,25000,50000,100000,250000,500000,1000000,2500000 -o {output.mcool}
