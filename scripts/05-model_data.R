#### Preamble ####
# Purpose: Models factors leading to unsolved homicides 
# in Chicago and Los Angeles from 2010 to 2017. 
# Author: Emily Su
# Date: 28 November 2024
# Contact: em.su@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have ran 00-install_packages.R, 02-download_data.R,
# 03-clean_data.R, and 04-test_analysis_data.R prior to install required
# packages, download our required dataset, clean the dataset, and test the
# dataset.
# NOTE: This script was checked through lintr for styling


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(arrow)

set.seed(646)

#### Read data ####
analysis_data_homicides <- 
  read_parquet("data/02-analysis_data/cleaned_data_homicides.parquet")

### Model data ####
# Logistic regression model for unsolved homicides 
unsolved_homicide_model <-
  stan_glm(
    formula = arrest_was_not_made ~ victim_race + victim_age + victim_sex + 
      city + year,
    data = analysis_data_homicides,
    family = binomial(link = "logit"),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
    seed = 646
  )

#### Save model ####
saveRDS(unsolved_homicide_model,
        file = "models/unsolved_homicide_model.rds")