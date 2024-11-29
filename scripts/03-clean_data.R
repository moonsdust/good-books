#### Preamble ####
# Purpose: Cleans the raw data about solved and unsolved homicides in large US
# cities and saves it as a Parquet file.
# Author: Emily Su
# Date: 19 November 2024
# Contact: em.su@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have ran 00-install_packages.R and 02-download_data.R 
# to install the necessary packages and download the dataset, respectively.
# NOTE: This script was checked through lintr for styling

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(lubridate)
library(arrow)

#### Clean data ####
raw_data_homicides <- read_csv("data/01-raw_data/raw_data_homicides.csv",
                               show_col_types = FALSE)
# Clean column name
cleaned_data_homicides <- clean_names(raw_data_homicides)

# Remove any blank rows for predictor variables that would be used in model
cleaned_data_homicides <- cleaned_data_homicides |> 
  filter(!is.na(victim_race)) |>
  filter(!is.na(victim_age)) |>
  filter(!is.na(victim_sex))
  

# First filter out rows where one of the following columns is contains 
# the value "Unknown": victim_race, victim_age, victim_sex
cleaned_data_homicides <- cleaned_data_homicides |>
  filter(victim_race != "Unknown",
         victim_age != "Unknown",
         victim_sex != "Unknown")

# Select the following rows: reported_date, victim_race, victim_age,
# victim_sex, city, state, lat, lon, disposition
cleaned_data_homicides <- cleaned_data_homicides |>
  select(reported_date, victim_race, victim_age,
         victim_sex, city, state, disposition)

# Split reported_date into year and month
# Referenced https://rawgit.com/rstudio/cheatsheets/main/lubridate.pdf
# Create column for year
cleaned_data_homicides$year <- year(ymd(cleaned_data_homicides$reported_date))
# Create column for month 
cleaned_data_homicides$month <- month(ymd(cleaned_data_homicides$reported_date))
# Now remove reported_date column 
cleaned_data_homicides <- cleaned_data_homicides |>
  select(-c(reported_date))

# Create a new column for arrest_was_made
# (where 1 = there was an arrest, 0 = open/no arrest/closed without arrest)
cleaned_data_homicides <- cleaned_data_homicides |>
  mutate(arrest_was_made = if_else(disposition == "Closed by arrest", 1, 0))
# Now remove disposition column
cleaned_data_homicides <- cleaned_data_homicides |>
  select(-c(disposition))

# Update data type of column
cleaned_data_homicides$victim_age <- as.integer(cleaned_data_homicides$victim_age)
cleaned_data_homicides$year <- as.integer(cleaned_data_homicides$year)
cleaned_data_homicides$month <- as.integer(cleaned_data_homicides$month)
cleaned_data_homicides$arrest_was_made <- as.integer(cleaned_data_homicides$arrest_was_made)

#### Save data ####
# Save cleaned data as a Parquet file
write_parquet(cleaned_data_homicides,
              "data/02-analysis_data/cleaned_data_homicides.parquet")
