#!/bin/bash
#SBATCH --job-name=EagleC2_plot-SVbreaks
#SBATCH --output=EagleC2_plot-SVbreaks.out
#SBATCH --error=EagleC2_plot-SVbreaks.err
#SBATCH --time=72:00:00
#SBATCH --cpus-per-task=30
#SBATCH --mem=64G
#SBATCH --partition=biosoc2

plot-SVbreaks --cool-uri {output.mcool}::resolutions/250000 \
                --balance-type ICE --breakpoint-coords chr1,pos1,chr2,pos2 \
                --window-width 5 -O {output_breakpoint-coords.png} --dpi 800
