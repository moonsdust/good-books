# Differences in Homicide Case Information Indicates Why Justice is Not Served: An analysis of solved and unsolved homicides from 2010 to 2017 in one of the United States' 2 largest cities, Chicago and Los Angeles

## Overview

Despite Chicago Mayor Brandon Johnson announcing in 2024 that the Chicago Police Department had the highest homicide clearance rate of 54% in years, homicide clearance rates across the United States (US) have been decreasing since 1980, with more homicides going unsolved. This paper looks at patterns of homicide case information with the case resolution from 2010 to 2017 in two of the largest cities in the United States, Chicago and Los Angeles. We found that unsolved homicides are more likely to occur in Chicago compared to Los Angeles, and the majority of unsolved homicide victims are Black or Hispanic and are male. These findings can inform the public and US police departments of populations more vulnerable to having unsolved cases however further investigation is needed on the investigators involved in each unsolved homicide case.

## Dashboard for Interactive Visualizations 

A dashboard containing interactive versions of the graphs found in this paper was developed using shiny, shinydashboard, and plotly. The link to the shiny app can be found here: https://49z7k8-emily-su.shinyapps.io/unsolved-homicides-app/

## File Structure

The repo is structured as:
-   `data/00-simulated_data` contains data obtained from simulation of ideal dataset for our analysis.
-   `data/01-raw_data` contains the raw data as obtained from The Washington Post.
-   `data/02-analysis_data` contains the cleaned dataset in parquet form and CSV form that was constructed and used in our analysis. Note that the CSV file in this folder is used for the dashboard only. 
-   `models` contains the fitted model. 
-   `other` contains sketches and the R script used to create the dashboard.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to install, simulate, download, clean, explore, and test data.


## Statement on LLM usage

No LLMs were used for any aspect of this work.