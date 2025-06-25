# LEAFY Gene Regulatory Network Analysis in Arabidopsis

## Overview

This directory contains scripts and analyses based on previous work from 2015 that explored LEAFY (LFY) gene regulatory networks in Arabidopsis thaliana. The analysis serves as a preliminary study to inform work on fern (Ceratopteris richardii) LFY networks, testing whether transcriptomic data can be used to identify meaningful LFY GRNs before applying similar approaches to fern.

## Background

LEAFY (LFY) is a conserved transcription factor found in all land plants:
- In angiosperms (like Arabidopsis), LFY is required for floral meristem specification
- In mosses, LFY is required for initial divisions of the zygote
- In ferns, the function is less clear, which is what prompted this comparative analysis

## Datasets Used

The analysis utilized two major microarray datasets:
1. **Schmid et al. (ME00317)**: Time course of floral induction where plants were moved from short day to long day with samples at 0, 3, 5, and 7 days
2. **Lohman et al. (ME00319)**: AtGenExpress developmental series with various tissues and developmental stages

## Analysis Approaches

Three main approaches were used to identify genes in the LFY regulatory network:

1. **WGCNA (Weighted Gene Co-expression Network Analysis)**:
   - Created gene modules based on correlation patterns
   - Identified modules containing LFY
   - Assessed module-trait relationships

2. **GeneNet Analysis**:
   - Used partial correlations to identify direct gene-gene interactions
   - Filtered for statistically significant connections

3. **Mutual Rank (MR) Analysis**:
   - Implemented in the `At_LFY_Networks_TimeCourse317.Rmd` script
   - Results stored in the `LFY.mr.results.Rdata` file
   - Calculated as the geometric mean of the correlation rank between gene pairs
   - More robust than simple correlation for identifying biologically meaningful connections
   - Showed better enrichment of known LFY targets and relevant GO terms than other methods
   - Tested various MR cutoffs (10, 20, 30, 50, 80, 100, 130, 210) to identify optimal network

## Analysis Scripts and Methods

### Data Subsetting and Analysis

Three different data subsets were explored from the AtGenExpress developmental series (ME00319):

#### Data Subset 1
Consisted of 28 samples including:
```
[1] "clv3-7_flow12"      "clv3-7_inflor"      "Col-0_cauline"     
[4] "Col-0_flow10/11"    "Col-0_flow12"       "Col-0_flow12_carp" 
[7] "Col-0_flow12_petal" "Col-0_flow12_sepal" "Col-0_flow12_stam" 
...and others
```
This subset contained many late stage floral organs.

#### Data Subset 2
Consisted of 24 samples with more vegetative tissues:
```
[1] "clv3-7_flow12"     "clv3-7_inflor"     "Col-0_cauline"    
[4] "Col-0_flow10/11"   "Col-0_flow12"      "Col-0_flow15"     
[7] "Col-0_flow9"       "Col-0_flower"      "Col-0_hyp"        
...and others
```

#### Data Subset 3
Consisted of 15 samples specifically selected for diversity in LFY expression levels:
```
[1] "Col-0_flow12_petal" "Col-0_shoot_trans"  "Col-0_inflo"       
[4] "clv3-7_inflor"      "ufo-1_inflor"       "lfy-12_inflor"     
[7] "Col-0_flow15_carp"  "Col-0_flow12_carp"  "clv3-7_flow12"     
...and others
```

### Script Descriptions

1. **At_LFY_Networks_TimeCourse317.Rmd**
   - Analyzed the Schmid et al. time course dataset (ME00317)
   - Processed and normalized microarray data with RMA
   - Performed WGCNA with different power parameters (6 and 10)
   - Identified gene modules and correlated them with developmental stages
   - Visualized network modules and their relationship to LFY expression
   - **Implemented the Mutual Rank (MR) analysis**, which showed the best results
   - Created MR networks with different cutoffs (10-210) and analyzed their properties
   - Compared MR networks to known LFY targets from published literature
   - Results saved in `LFY.mr.results.Rdata` file

2. **At_LFY_319_set3.Rmd**
   - Focused on the third data subset from Lohman et al. dataset (ME00319)
   - Selected samples based on diversity of LFY expression
   - Normalized data and performed WGCNA analysis
   - Tested different soft thresholding powers to optimize network topology
   - Generated gene modules and analyzed their correlation with LFY

3. **GeneNet.Rmd**
   - Used GeneNet package for partial correlation network analysis
   - Filtered genes based on coefficient of variation (>0.04)
   - Estimated partial correlations between genes
   - Identified edges (connections) between LFY and other genes
   - Retrieved annotations for LFY-connected genes

4. **2015 07 27 Group Meeting LFY networks.Rpres/md**
   - Presentation summarizing the analyses and results
   - Compared results from different data subsets
   - Evaluated overlap between identified genes and known LFY targets
   - Presented GO enrichment analyses of LFY-correlated genes
   - **Highlighted the success of the Mutual Rank approach**
   - Showed that MR=80 cutoff yielded a network of 42 genes with strong enrichment for floral organ identity genes
   - Concluded that MR was the most effective approach compared to simple correlation or WGCNA

## Results Summary

### WGCNA and Correlation Analysis Results
The three data subset approaches with WGCNA and simple correlation didn't work well for identifying LFY gene networks, based on:
- Large number of genes in LFY modules (698 genes) with WGCNA
- Failure to achieve scale-free topology in WGCNA analysis
- Limited overlap with known LFY target genes
- Limited enrichment of meaningful GO categories

### Mutual Rank Analysis Results
The Mutual Rank approach proved much more successful:
- MR=80 cutoff yielded a network of 42 genes
- 29% of genes in this network were known LFY targets (12 genes overlap)
- Highly significant GO enrichment for relevant terms:
  - Specification of organ identity (p=0.000024)
  - Specification of floral organ identity (p=0.000024)
  - Floral meristem determinacy (p=0.000637)
- Lower MR cutoffs (10, 20) showed even higher percentages of known targets (100% and 83% respectively) but with smaller networks

### Key Findings
1. Mutual Rank analysis outperformed both WGCNA and simple correlation approaches
2. MR=80 represented a good balance between network size and target enrichment
3. The MR approach recovered known biological functions of LFY in floral organ specification

These findings suggest that:
1. Standard co-expression approaches may not be optimal for transcription factors with complex expression patterns
2. Mutual Rank provides a more robust metric for identifying biologically meaningful connections
3. For future fern work, MR analysis should be prioritized over WGCNA or simple correlation

## File Organization