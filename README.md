Adamson_Waterbuck_Hi-C
# Reproducible Workflow for Hi-C Variant Calling and Variant Heatmap Visualisation

### Software Requirements

#### Conda or Miniconda3:
-  mkdir -p ~/miniconda3
-  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
-  bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3

#### HiCExplorer:
- conda install bioconda::hicexplorer
  
#### Cooler:
- conda install bioconda::cooler
  
#### EagleC2:
- conda config --add channels defaults
- conda config --add channels bioconda
- conda config --add channels conda-forge
- mamba create -n EagleC scikit-learn statsmodels matplotlib cooler pyBigWig pyensembl python=3.8 joblib=1.0.1 cython=0.29.24 "tensorflow<=2.11"
  
#### Python 3:
- conda install conda-forge::python

## Step 1: Generate a 1kb H5 file

Follow https://github.com/Farre-lab/Kirkland_Bovidae/tree/main/Hi-C workflow
Modify BinSize to 1kb in: https://github.com/Farre-lab/Kirkland_Bovidae/blob/main/Hi-C/4_HiCExplorer1.sh 
To generate a 1kb Hi-C matrix


## Step 2: Perform Normalization of 1kb H5 file

Follow: https://github.com/Farre-lab/Kirkland_Bovidae/blob/main/Hi-C/5_HiCExplorer2.sh


## Step 3: Perform Correction of Normalized 1kb H5 file

Follow: https://github.com/Farre-lab/Kirkland_Bovidae/blob/main/Hi-C/6_HiCExplorer3.sh


## Step 4: Convert Normalized, Corrected H5 file to 1kb COOL file

hicConvertFormat --matrices {normalized_corrected.h5} --outFileName {output_1Kb.cool}  --inputFormat h5 --outputFormat cool


## Step 5: Convert 1kb COOL file to MCOOL file with cooler zoomify

cooler zoomify {output_1kb.cool} --resolutions 1000,5000,10000,25000,50000,100000,250000,500000,1000000,2500000 -o {output.mcool}


## Step 6: Perform Cooler Balance on MCOOL file

cooler balance {output.mcool}::/resolutions/1000
Repeat for the following resolutions: 5000, 10000, 25000, 50000, 100000, 250000, 500000, 1000000 and 2500000 (These are the same resolutions generated in the mcool file)


## Step 7: Structural Variant Calling with EagleC2
- This step generates a structural variant call file (`{file_name}.SV_calls.txt`) and a ({file_name}.log) file.

predictSV --mcool {output.mcool} --resolutions 50000,100000,250000,500000 --prob-cutoff-1 0.3 --prob-cutoff-2 0.3 -O {file_name} -g other --balance-type ICE -p 8 --intra-extend-size 1,1,1,1 --inter-extend-size 1,1,1,1


## Step 8: Hi-C Variant Heatmap Visualisation 
- Generates heatmap of input Hi-C variant coordinates

plot-SVbreaks --cool-uri {output.mcool}::resolutions/250000 \
                --balance-type ICE --breakpoint-coords chr1,pos1,chr2,pos2 \
                --window-width 5 -O {output.png} --dpi 800


## Step 9 (OPTIONAL): Visualising Heatmap of Whole Chromosome Interactions 
- Firstly, a 500kb resolution h5 file needs to be generated - this follows the following script exactly: https://github.com/Farre-lab/Kirkland_Bovidae/blob/main/Hi-C/4_HiCExplorer1.sh

- Visualising Whole Chromosome Interactions - Heatmap Generation:

hicPlotMatrix -m {500kb.h5} --dpi 800 --chromosomeOrder chr1 chr2 -o {output.png} --log1p

OR optionally

plot-interSVs \
  --cool-uri {output.mcool}::resolutions/500000 \
  --sv-file {SV_calls.txt} \
  -C chr1 chr2 \
  -O {output.png} \
  --balance-type ICE \
  --dpi 800

Reproducible Workflow for Calculating the Interchromosomal Interactions Mean Contact Intensity (CI) and Generating Heatmap Visualisation of the Mean CI
Software Requirements:
HiCExplorer
Tidyverse
ggplot2
Step 1: Generate a 500kb H5 file
Follow: https://github.com/Farre-lab/Kirkland_Bovidae/blob/main/Hi-C/4_HiCExplorer1.sh to generate a 500kb Hi-C matrix

Step 2: Perform Normalization of 500kb H5 file
Follow: https://github.com/Farre-lab/Kirkland_Bovidae/blob/main/Hi-C/5_HiCExplorer2.sh

Step 3: Perform Correction of Normalized 500kb H5 file
Follow: https://github.com/Farre-lab/Kirkland_Bovidae/blob/main/Hi-C/6_HiCExplorer3.sh

Step 4: Convert Normalized, Corrected H5 file to 500kb GINTERACTIONS file
hicConvertFormat --matrices {normalized_corrected.h5} --outFileName {output_500Kb.ginteractions.tsv} --inputFormat h5 --outputFormat ginteractions

Step 5: Extract Interchromosomal Interactions from GINTERACTIONS file
awk '$1 != $4 {print}' {output_500Kb.ginteractions.tsv} > {Interchromosomal_Interactions.ginteractions.tsv}

Step 6: (IF NECESSARY) Remove Scaffolds from GINTERACTIONS file
awk '$1 ~ /^chr/ && $4 ~ /^chr/' {Interchromosomal_Interactions.ginteractions.tsv} > {Output.ginteractions.tsv}

Step 7: Calculate Mean Contact Intensity (CI) for all possible Interchromosomal Interactions
Import the {Output.ginteractions.tsv} file into R and save it as a data frame.
Calculate the mean contact intensity (CI) for each chromosome pair using the interaction counts in column X7.
This code stores the calculated values in a new data frame containing all interchromosomal chromosome pairs (Waterbuck_Interchromosomal_Interaction_Pairs).
The first row of the interchromosomal chromosome-pair file is a buffer row set to 0. This is required because mean contact intensity values are assigned using counter + 1. The buffer row ensures that each calculated mean is written to the correct chromosome-pair row and prevents a one-row offset in the output file.
chromosomes <- c(paste0("chr", 1:26), "chrX")

counter <- 1

for (i in seq_along(chromosomes)) {

for (j in i:length(chromosomes)) {

Waterbuck_Interchromosomal_Interaction_Pairs$mean[counter] <- mean(
  Output.ginteractions.tsv$X7[
    Output.ginteractions.tsv$X1 == chromosomes[i] &
      Output.ginteractions.tsv$X4 == chromosomes[j]
  ],
  na.rm = TRUE
)

counter <- counter + 1
}

If any mean contact intensity values return 'NaN' use the following code:
Waterbuck_Interchromosomal_Interaction_Pairs$mean[c(n)] <- mean(Output.ginteractions.tsv$X7[Output.ginteractions.tsv$X1 == "chr1" & Output.ginteractions.tsv$X4 == "chr2"], na.rm = TRUE)
Step 8: Calculate the Overall Mean Contact Intensity
This is used to set the gradient for the heatmap plot
mean(Waterbuck_Interchromosomal_Interaction_Pairs$mean)

Step 9: Create the Heatmap with ggplot2
Chromosomes must be represented as numeric values for plotting. In this example, chrX was recoded as chromosome 27.
The chromosome range (1:27) corresponds to the Defassa waterbuck karyotype (2n = 54) and should be adjusted accordingly for other species.
The midpoint value sets the colour gradient for the heatmap
ggplot(Waterbuck_Interchromosomal_Interaction_Pairs$mean, aes(x = Waterbuck_Interchromosomal_Interaction_Pairs$Mean_CI$X1, y = Waterbuck_Interchromosomal_Interaction_Pairs$Mean_CI$X2, fill = Waterbuck_Interchromosomal_Interaction_Pairs$Mean_CI$X3)) + geom_tile() + scale_x_continuous( breaks = 1:27,
labels = 1:27 ) + scale_y_continuous( breaks = 1:27,
labels = 1:27 # Show all Y values ) + scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = Overall_Mean_Contact_Intensity)
