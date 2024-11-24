#### Preamble ####
# Purpose: Installs packages needed to run scripts and Quarto document
# Author: Emily Su
# Date: 16 November 2024
# Contact: em.su@mail.utoronto.ca
# License: MIT
# Pre-requisites: -
# NOTE: This script was checked through lintr for styling

#### Workspace setup ####
## Installing packages (only needs to be done once per computer)
install.packages("tidyverse") # Contains data-related packages
install.packages("janitor") # To clean datasets
install.packages("lubridate")
install.packages("dplyr")
install.packages("ggplot2") # To make graphs
install.packages("lintr") # To check styling of code
install.packages("styler") # To style code
install.packages("arrow")