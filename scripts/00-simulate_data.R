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
# Expected Columns: victim_race, victim_age, victim_sex, city
# disposition, year, month, arrest_was_not_made

# victim_race
victim_race <- c(
  "White",
  "Black",
  "Asian",
  "Hispanic",
  "Other"
)

# victim_age
victim_age <- c(0:100)

# victim_sex
victim_sex <- c("Female", "Male")

# city
city <- c("Chicago", "Los Angeles")

# disposition 
disposition <- c("Closed by arrest", 
          "Closed without arrest",
          "Open/No arrest")

# year
year <- c(2010:2017)

# month 
month <- c(1:12)

# arrest_was_not_made
arrest_was_not_made <- c(0:1)


# Create a dataset by randomly assigning the variables defined above 
simulated_data <- tibble(
  victim_race = sample(
    victim_race,
    size = 1000,
    replace = TRUE
  ),
  victim_age = sample(
    victim_age,
    size = 1000,
    replace = TRUE
  ),
  victim_sex = sample(
    victim_sex,
    size = 1000,
    replace = TRUE
  ),
  city = sample(
    city,
    size = 1000,
    replace = TRUE
  ),
  disposition = sample(
    disposition,
    size = 1000,
    replace = TRUE
  ),
  year = sample(
    year,
    size = 1000,
    replace = TRUE
  ),
  month = sample(
    month,
    size = 1000,
    replace = TRUE
  ),
  arrest_was_not_made = sample(
    arrest_was_not_made,
    size = 1000,
    replace = TRUE
  )
)


#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
