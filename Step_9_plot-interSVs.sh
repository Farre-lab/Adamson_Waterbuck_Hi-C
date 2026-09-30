#!/bin/bash
#SBATCH --job-name=Whole_Chromosome_Interactions_plot-interSVs
#SBATCH --output=Whole_Chromosome_Interactions_plot-interSVs.out
#SBATCH --error=Whole_Chromosome_Interactions_plot-interSVs.err
#SBATCH --time=72:00:00
#SBATCH --cpus-per-task=30
#SBATCH --mem=64G
#SBATCH --partition=biosoc2

plot-interSVs \
  --cool-uri {output.mcool}::resolutions/500000 \
  --sv-file {SV_calls.txt} \
  -C chr1 chr2 \
  -O {output.png} \
  --balance-type ICE \
  --dpi 800
