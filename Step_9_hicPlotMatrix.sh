#!/bin/bash
#SBATCH --job-name=Whole_Chromosome_Interactions_hicPlotMatrix
#SBATCH --output=Whole_Chromosome_Interactions_hicPlotMatrix.out
#SBATCH --error=Whole_Chromosome_Interactions_hicPlotMatrix.err
#SBATCH --time=72:00:00
#SBATCH --cpus-per-task=30
#SBATCH --mem=64G
#SBATCH --partition=biosoc2

hicPlotMatrix -m {500kb.h5} --dpi 800 --chromosomeOrder chr1 chr2 -o {output.png} --log1p
