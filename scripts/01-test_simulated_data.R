#### Preamble ####
# Purpose: Tests the structure and validity of the simulated homicide dataset.
# Author: Emily Su
# Date: 3 December 2024
# Contact: em.su@mail.utoronto.ca. 
# License: MIT
# Pre-requisites: 00-install_packages.R and 00-simulate_data.R have 
# been ran prior to install the necessary packages and simulate the dataset.
# NOTE: This script was checked through lintr for styling


#### Workspace setup ####
library(tidyverse)
library(testthat)

simulated_data <- read_csv("data/00-simulated_data/simulated_data.csv",
                           show_col_types = FALSE)

# Test if the simulated data was successfully loaded
if (exists("simulated_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}


#### Test data ####

# Check if the dataset has 1000 rows
if (nrow(simulated_data) == 1000) {
  message("Test Passed: The dataset has 1000 rows.")
} else {
  stop("Test Failed: The dataset does not have 1000 rows.")
}

# Check if the dataset has 8 columns
if (ncol(simulated_data) == 8) {
  message("Test Passed: The dataset has 8 columns.")
} else {
  stop("Test Failed: The dataset does not have 8 columns.")
}

# Test that there are no missing values in the dataset
expect_true(all(!is.na(simulated_data)))

stopifnot(
  # Will return NULL if all checks inside here is True
  
  # The victim's race is "Hispanic", "White", "Other", "Black", or "Asian"   
  simulated_data$victim_race |> unique() %in% 
    c("Hispanic", "White", "Other","Black", "Asian"),
  
  # The youngest victims' age is greater than or equal to 0 
  simulated_data$victim_age |> min() >= 0, 
  
  # The victim's sex is "Female" or "Male" 
  # (This is based on the unique values under this column)
  simulated_data$victim_sex |> unique() %in% c("Female", "Male"),
  
  # Check if there are 2 cities in the city column
  simulated_data$city |> unique() |> as_tibble() |> count() == 2,
  
  # Check if the 2 cities in the city column are either New York or 
  # Los Angeles 
  simulated_data$city |> unique() %in% c("Chicago", "Los Angeles"),
  
  # Check if the disposition column contains 3 types of values: 
  # Closed by arrest, Closed without arrest, and Open/No arrest
  simulated_data$disposition |> unique() %in% c("Closed by arrest",
                                                "Closed without arrest",
                                                "Open/No arrest")
  
)

# Test that the 'victim_race' column is character 
expect_type(simulated_data$victim_race, "character")

# Test that the 'victim_sex' column is character type
expect_type(simulated_data$victim_sex, "character")

# Test that the 'victim_age' column is double type
expect_type(simulated_data$victim_age, "double")

# Test that the 'city' column is character type
expect_type(simulated_data$city, "character")

# Test that the 'disposition' column is character type
expect_type(simulated_data$disposition, "character")

# Test that the 'year' column is double type
expect_type(simulated_data$year, "double")

# Test that the 'month' column is double type
expect_type(simulated_data$month, "double")

# Test that the 'arrest_was_not_made' column is double type
expect_type(simulated_data$arrest_was_not_made, "double")

# Test that 'year' contains years from 2010 to 2017
expect_true(all(simulated_data$year %in% c(2010:2017)))

# Test that 'month' contains only numbers from 1 to 12 
expect_true(all(simulated_data$month %in% c(1:12)))

# Test that 'arrest_was_not_made' is either 0 or 1 
expect_true(all(simulated_data$arrest_was_not_made %in% c(0, 1)))

# Test that there are no empty strings in 'victim_race', 'victim_sex', 
# 'city', and 'disposition' columns
expect_false(any(simulated_data$victim_race == "" | 
                   simulated_data$victim_sex == "" | 
                   simulated_data$city == "" |
                   simulated_data$disposition == ""))
