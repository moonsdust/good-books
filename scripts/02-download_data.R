#### Preamble ####
# Purpose: Downloads and saves the data from the GitHub repo owned by 
# The Washington Post containing information of homicides in 50 of the 
# largest US cities from 2010 to 2017.
# Author: Emily Su
# Date: 16 November 2024
# Contact: em.su@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have ran 00-install_packages.R beforehand to install the
# necessary packages.
# NOTE: This script was checked through lintr for styling


#### Workspace setup ####
library(tidyverse)

#### Download data ####
# Dataset (Unsolved Homicide Database):
# https://github.com/washingtonpost/data-homicides

# 1. Obtain The Washington Posts's Unsolved Homicide Dataset from GitHub
data_homicides_dataset <- 
  read_csv("https://raw.githubusercontent.com/washingtonpost/data-homicides/refs/heads/master/homicide-data.csv", show_col_types = FALSE)
# NOTE: If the name of the file changes or you are unable to read in the
# CSV file, please head to https://github.com/washingtonpost/data-homicides
# for the new name of the CSV file. 

#### Save data ####
write_csv(data_homicides_dataset, "data/01-raw_data/raw_data_homicides.csv") 