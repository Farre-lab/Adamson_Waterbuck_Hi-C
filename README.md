# Reproducible Workflow for Calculating the Interchromosomal Interactions Mean Contact Intensity (CI) and Heatmap Visualisation of the Mean CI

### Software Requirements:
- HiCExplorer
- Tidyverse
- ggplot2


## Step 1: Generate a 500kb H5 file

Follow: https://github.com/Farre-lab/Kirkland_Bovidae/blob/main/Hi-C/4_HiCExplorer1.sh to generate a 500kb Hi-C matrix


## Step 2: Perform Normalization of 500kb H5 file

Follow: https://github.com/Farre-lab/Kirkland_Bovidae/blob/main/Hi-C/5_HiCExplorer2.sh


## Step 3: Perform Correction of Normalized 500kb H5 file

Follow: https://github.com/Farre-lab/Kirkland_Bovidae/blob/main/Hi-C/6_HiCExplorer3.sh


## Step 4: Convert Normalized, Corrected H5 file to 500kb GINTERACTIONS file

hicConvertFormat --matrices {normalized_corrected.h5} --outFileName {output_500Kb.ginteractions.tsv}  --inputFormat h5 --outputFormat ginteractions


## Step 5: Extract Interchromosomal Interactions from GINTERACTIONS file
awk '$1 != $4 {print}' {output_500Kb.ginteractions.tsv} > {Interchromosomal_Interactions.ginteractions.tsv}

## Step 6: (IF NECESSARY) Remove Scaffolds from GINTERACTIONS file 

awk '$1 ~ /^chr/ && $4 ~ /^chr/' {Interchromosomal_Interactions.ginteractions.tsv} > {Output.ginteractions.tsv}


## Step 7: Calculate Mean Contact Intensity (CI) for all possible Interchromosomal Interactions
- Import the {Output.ginteractions.tsv} file into R and save it as a data frame.
- Calculate the mean contact intensity (CI) for each chromosome pair using the interaction counts in column X7.
- This code stores the calculated values in a new data frame containing all interchromosomal chromosome pairs (Waterbuck_Interchromosomal_Interaction_Pairs).
- The first row of the interchromosomal chromosome-pair file is a buffer row set to 0. This is required because mean contact intensity values are assigned using counter + 1. The buffer row ensures that each calculated mean is written to the correct chromosome-pair row and prevents a misalignment in the output file.

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
 }  
 
-  If any mean values return Nan use the following code:
- Waterbuck_Interchromosomal_Interaction_Pairs$mean[c(n)] <- mean(Output.ginteractions.tsv$X7[Output.ginteractions.tsv$X1 == "{chr}" & Output.ginteractions.tsv$X4 == "{chr}"], na.rm = TRUE)


## Step 8: Calculate the Overall Mean Contact Intensity
- This is used to set the gradient for the heatmap plot

mean(Waterbuck_Interchromosomal_Interaction_Pairs$mean)


## Step 9: Create the Heatmap with ggplot2
- Chromosomes must be represented as numeric values for plotting. In this example, chrX was recoded as chromosome 27. 
- The chromosome range (1:27) corresponds to the Defassa waterbuck karyotype (2n = 54) and should be adjusted accordingly for other species.
- The midpoint value sets the colour gradient for the heatmap


ggplot(Waterbuck_Interchromosomal_Interaction_Pairs$Mean_CI, aes(x = Waterbuck_Interchromosomal_Interaction_Pairs$Mean_CI$X1, y = Waterbuck_Interchromosomal_Interaction_Pairs$Mean_CI$X2, fill = Waterbuck_Interchromosomal_Interaction_Pairs$Mean_CI$X3)) + geom_tile() +
  scale_x_continuous(
    breaks = 1:27,                
    labels = 1:27
  ) +
  scale_y_continuous(
    breaks = 1:27,                
    labels = 1:27
    # Show all Y values
  )  + scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = Overall_Mean_Contact_Intensity)
