#!/bin/bash
#SBATCH --job-name=Cooler_Balance_Script
#SBATCH --output=Cooler_Balance_Script.out
#SBATCH --error=Cooler_Balance_Script.err
#SBATCH --time=72:00:00
#SBATCH --cpus-per-task=30
#SBATCH --mem=64G
#SBATCH --partition=biosoc2

# Cooler balance ensures that data is distibuted equally across resolutions (Bin sizes)

cooler balance {output.mcool}::/resolutions/1000
cooler balance {output.mcool}::/resolutions/5000
cooler balance {output.mcool}::/resolutions/10000
cooler balance {output.mcool}::/resolutions/25000
cooler balance {output.mcool}::/resolutions/50000
cooler balance {output.mcool}::/resolutions/100000
cooler balance {output.mcool}::/resolutions/250000
cooler balance {output.mcool}::/resolutions/500000
cooler balance {output.mcool}::/resolutions/1000000
cooler balance {output.mcool}::/resolutions/2500000
