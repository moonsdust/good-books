#### Preamble ####
# Purpose: Tests the analysis data on solved and unsolved homicides in the US.
# Author: Emily Su
# Date: 28 November 2024 
# Contact: em.su@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have ran 00-install_packages.R, 02-download_data.R,
# 03-clean_data.R previously to install necessary packages, 
# download the raw data, and clean the raw data into a parquet file. 
# NOTE: This script was checked through lintr for styling


#### Workspace setup ####
library(tidyverse)
library(testthat)
library(arrow)

analysis_data_homicides <- 
  read_parquet("data/02-analysis_data/cleaned_data_homicides.parquet")


#### Test data ####

# Test that the dataset has 8 columns
expect_equal(ncol(analysis_data_homicides), 8)

# Test that there are no missing values in the dataset
expect_true(all(!is.na(analysis_data_homicides)))

# Test that the 'victim_race' column is character type
expect_type(analysis_data_homicides$victim_race, "character")

# Test that the 'victim_age' column is numeric type
expect_type(analysis_data_homicides$victim_age, "integer")

# Test that the 'victim_sex' column is character type
expect_type(analysis_data_homicides$victim_sex, "character")

# Test that the 'city' column is character type
expect_type(analysis_data_homicides$city, "character")

# Test that the 'state' column is character type
expect_type(analysis_data_homicides$state, "character")

# Test that the 'year' column is integer type
expect_type(analysis_data_homicides$year, "integer")

# Test that the 'month' column is integer type
expect_type(analysis_data_homicides$month, "integer")

# Test that the 'arrest_was_made' column is integer type
expect_type(analysis_data_homicides$arrest_was_made, "integer")

stopifnot(
  # Will return NULL if all checks inside here is True
  
  # The victim's race is "Hispanic", "White", "Other", "Black", or "Asian"   
  analysis_data_homicides$victim_race |> unique() %in% 
    c("Hispanic", "White", "Other","Black", "Asian"),
  
  # The youngest victims' age is greater than or equal to 0 
  analysis_data_homicides$victim_age |> min() >= 0, 
  
  # The victim's sex is "Female" or "Male" 
  # (This is based on the unique values under this column)
  analysis_data_homicides$victim_sex |> unique() %in% c("Female", "Male"),
  
  # Check if there are less than or equal to 50 cities 
  analysis_data_homicides$city |> unique() |> as.tibble() |> count() <= 50,
  
  # Check if the state column contains less than or equal to the 50 states 
  analysis_data_homicides$state |> unique() |> as.tibble() |> count() <= 50
)

# Test that 'year' contains years from 2007 to 2017
expect_true(all(analysis_data_homicides$year %in% c(2007:2017)))

# Test that 'month' contains only numbers from 1 to 12 
expect_true(all(analysis_data_homicides$month %in% c(1:12)))

# Test that 'arrest_was_made' is either 0 or 1 
expect_true(all(analysis_data_homicides$arrest_was_made %in% c(0, 1)))

# Test that there are no empty strings in 'victim_race', 'victim_sex', 
# 'city', and 'state' columns
expect_false(any(analysis_data_homicides$victim_race == "" | 
                   analysis_data_homicides$victim_sex == "" | 
                   analysis_data_homicides$city == "" |
                   analysis_data_homicides$state == ""))