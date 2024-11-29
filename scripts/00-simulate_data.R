#### Preamble ####
# Purpose: Simulates homicide dataset regarding solved and unsolved cases. 
# Author: Emily Su
# Date: 19 November 2024
# Contact: em.su@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have ran 00-install_packages.R beforehand to install the
# necessary packages.
# NOTE: This script was checked through lintr for styling


#### Workspace setup ####
library(tidyverse)
set.seed(646)


#### Simulate data ####
# Expected Columns: 




# State names
states <- c(
  "New South Wales",
  "Victoria",
  "Queensland",
  "South Australia",
  "Western Australia",
  "Tasmania",
  "Northern Territory",
  "Australian Capital Territory"
)

# Political parties
parties <- c("Labor", "Liberal", "Greens", "National", "Other")

# Create a dataset by randomly assigning states and parties to divisions
analysis_data <- tibble(
  division = paste("Division", 1:151),  # Add "Division" to make it a character
  state = sample(
    states,
    size = 151,
    replace = TRUE,
    prob = c(0.25, 0.25, 0.15, 0.1, 0.1, 0.1, 0.025, 0.025) # Rough state population distribution
  ),
  party = sample(
    parties,
    size = 151,
    replace = TRUE,
    prob = c(0.40, 0.40, 0.05, 0.1, 0.05) # Rough party distribution
  )
)


#### Save data ####
write_csv(analysis_data, "data/00-simulated_data/simulated_data.csv")
