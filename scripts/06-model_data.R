#### Preamble ####
# Purpose: Models characteristics of victims of unsolved homicides 
# in the 4 largest US cities from 2007 to 2017. 
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
# Logistic regression model for unsolved homicide victims with 
# victim_race, victim_age, and victim_sex as fixed effects

# Update the baseline for victim race to White
# Referenced: 
# https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/relevel

analysis_data_homicides$victim_race <- 
  relevel(analysis_data_homicides$victim_race, ref = "White")

unsolved_homicide_victim_model <-
  stan_glm(
    formula = arrest_was_not_made ~ victim_race + victim_age + victim_sex,
    data = analysis_data_homicides,
    family = binomial(link = "logit"),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
    seed = 646
  )

#### Save model ####
saveRDS(unsolved_homicide_victim_model,
        file = "models/unsolved_homicide_victim_model.rds")