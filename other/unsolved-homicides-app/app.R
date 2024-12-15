# Purpose: Builds shiny app to create interactive visualization based on paper.
# Author: Emily Su
# Date: 3 December 2024
# Contact: em.su@mail.utoronto.ca
# License: MIT
# Pre-requisites: All scripts in the scripts folder have been ran.
# NOTE: The code in this script was styled using styler
# Referenced:
# https://tellingstorieswithdata.com/05-graphs_tables_maps.html for code

library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(tidyverse)
library(dplyr)

# Read in cleaned dataset for Shiny app
data_for_shiny_app <-
  read_csv("https://raw.githubusercontent.com/moonsdust/unsolved-murders/109324a32ddd083eb910dd73431545474fb42bb6/data/02-analysis_data/cleaned_data_homicides.csv",
           show_col_types = FALSE)

# Referenced https://rstudio.github.io/shinydashboard/get_started.html
# in process of developing the dashboard

# Define UI for the application
ui <- dashboardPage(
  # Referenced
  # https://www.geeksforgeeks.org/how-to-change-color-in-shiny-dashboard/
  # to change colour of dashboard
  skin = "purple", 
  # Header of the dashboard
  dashboardHeader(title = "Unsolved Homicides"),
  # Sidebar of the dashboard
  dashboardSidebar(
    # Div contain information about the Shiny app
    div(class = "about", p("A dashboard with interactive versions of the graphs 
    found in the paper, \"Differences in Homicide Case Information Indicates
                           Why Justice is Not Served\". For more information, 
                           hover over the graphs.",
                           align = "center", width = "50%")),
    # Slider to adjust the number of bins 
    sliderInput("number_of_bins", "Number of bins:", 1, 100, 50),
    # Colour selector for main colour
    selectInput("colour_of_graphs_main",
    "What is the colour do you want the graphs to primarily be in? 
    Colours are in HEX code.", c("#7f4f24", "#d8dac8", "#bcbddc", "#a4ac86",
                                 "#d8b365", "#67a9cf", "#fc8d59")),
    # Colour selector for secondary colour
    selectInput("colour_of_graphs_secondary", 
                "What is the colour do you want to use to represent secondary
                groups in graphs? 
                Colours are in HEX code.",
                c("#d8dac8", "#7f4f24", "#67a9cf", "#a4ac86",
                  "#d8b365", "#fc8d59", "#bcbddc"))
  ),
  # Body of the dashboard
  dashboardBody(
    tabBox(
      title = "Differences in Homicide Case Information Between Solved and
      Unsolved Cases in Chicago and Los Angeles (2010 to 2017)",
      # The id lets us use input$tabset1 on the server to find the current tab
      id = "tabset1", width = "100%",
      tabPanel("Date (Month and Year)", plotlyOutput("heatmap")),
      tabPanel("Date (Month)", plotlyOutput("month")),
      tabPanel("Date (Year)", plotlyOutput("year")),
      tabPanel("Disposition", plotlyOutput("disposition")),
      tabPanel("City", plotlyOutput("city")),
      tabPanel("Victim's Age", plotlyOutput("victim_age")),
      tabPanel("Victim's Sex", plotlyOutput("victim_sex")),
      tabPanel("Victim's Race", plotlyOutput("victim_race"))
    ),
  )
)

# Define server logic
server <- function(input, output) {
  # The graphs 
  # Date (Month and Year)
  output$month <- renderPlotly({
    number_of_cases_month <- 
      data_for_shiny_app |>
      # Group by solved and unsolved homicides 
      group_by(arrest_was_not_made) |>
      # Count number of solved and unsolved homicides for each month
      count(month)|>
      # Rename count column
      rename(
        "num_of_cases_month" = n
      ) |>
      mutate(
        month = case_when(
          (month == 1) ~ "Jan",
          (month == 2) ~ "Feb",
          (month == 3) ~ "Mar",
          (month == 4) ~ "Apr",
          (month == 5) ~ "May",
          (month == 6) ~ "Jun",
          (month == 7) ~ "Jul",
          (month == 8) ~ "Aug",
          (month == 9) ~ "Sep",
          (month == 10) ~ "Oct",
          (month == 11) ~ "Nov",
          (month == 12) ~ "Dec",
          TRUE ~ "None")
      ) |>
      mutate(
        arrest_was_not_made = case_when(
          (arrest_was_not_made == 1) ~ "Arrest was not made",
          (arrest_was_not_made == 0) ~ "Arrest was made",
          TRUE ~ "None")
      )
    
    # To sort month in certain order 
    # Referenced:
    # https://www.geeksforgeeks.org/how-to-put-x-axis-in-order-month-in-r/
    # for code
    number_of_cases_month$month <- factor(number_of_cases_month$month,
                                          levels = c('Jan', 'Feb', 'Mar',
                                                     'Apr', 'May', 'Jun',
                                                     'Jul', 'Aug', 'Sep',
                                                     'Oct', 'Nov', 'Dec'))
    
    number_of_cases_month |>
      ggplot(mapping = aes(x = month, y = num_of_cases_month)) +
      # Creates two graphs based on the status of the case
      facet_wrap(facets = vars(arrest_was_not_made), dir = "v") +
      geom_bar(stat = "identity", fill = input$colour_of_graphs_main) +
      theme_minimal() +
      labs(x = "Month of the year", y = "Number of homicide cases") +
      theme(legend.position = "bottom")
  })
  
  output$year <- renderPlotly({
    number_of_cases_year <- 
      data_for_shiny_app |>
      # Group by solved and unsolved homicides 
      group_by(arrest_was_not_made) |>
      # Count number of solved and unsolved homicides for each year
      count(year)|>
      # Rename count column
      rename(
        "num_of_cases_year" = n
      ) |>
      mutate(
        arrest_was_not_made = case_when(
          (arrest_was_not_made == 1) ~ "Arrest was not made",
          (arrest_was_not_made == 0) ~ "Arrest was made",
          TRUE ~ "None")
      )
    number_of_cases_year |>
      ggplot(mapping = aes(x = as.character(year), y = num_of_cases_year)) +
      # Creates two graphs based on the status of the case
      facet_wrap(facets = vars(arrest_was_not_made), dir = "v") +
      geom_bar(stat = "identity", fill = input$colour_of_graphs_main) +
      theme_minimal() +
      labs(x = "Year", y = "Number of homicide cases") +
      theme(legend.position = "bottom")
  })
  
  output$heatmap <- renderPlotly({
    number_of_cases_year_month <- 
      data_for_shiny_app |>
      # Group by solved and unsolved homicides and year
      group_by(arrest_was_not_made, year) |>
      # Count number of solved and unsolved homicides for each month per year 
      count(month)|>
      # Rename count column
      rename(
        "num_of_cases_month_year" = n
      ) |>
      mutate(
        month = case_when(
          (month == 1) ~ "Jan",
          (month == 2) ~ "Feb",
          (month == 3) ~ "Mar",
          (month == 4) ~ "Apr",
          (month == 5) ~ "May",
          (month == 6) ~ "Jun",
          (month == 7) ~ "Jul",
          (month == 8) ~ "Aug",
          (month == 9) ~ "Sep",
          (month == 10) ~ "Oct",
          (month == 11) ~ "Nov",
          (month == 12) ~ "Dec",
          TRUE ~ "None")
      ) |>
      mutate(
        arrest_was_not_made = case_when(
          (arrest_was_not_made == 1) ~ "Arrest was not made",
          (arrest_was_not_made == 0) ~ "Arrest was made",
          TRUE ~ "None")
      )
    
    # To sort month in certain order 
    # Referenced:
    # https://www.geeksforgeeks.org/how-to-put-x-axis-in-order-month-in-r/
    # for code
    number_of_cases_year_month$month <-
      factor(number_of_cases_year_month$month,
             levels = c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug',
                        'Sep', 'Oct', 'Nov', 'Dec'))
    
    # Referenced:
    # https://stackoverflow.com/questions/12998372/heatmap-like-plot-but-for-categorical-variables
    # to help create heatmap
    number_of_cases_year_month |>
      ggplot(mapping = aes(x = month, y = year)) +
      geom_tile(aes(fill = num_of_cases_month_year)) + 
      # Creates two graphs based on the status of the case
      facet_wrap(facets = vars(arrest_was_not_made), dir = "v") +
      scale_fill_gradient(low = input$colour_of_graphs_main, 
                          high = input$colour_of_graphs_secondary,
                          name = "Number of homicides") +
      theme_minimal() +
      labs(x = "Month", y = "Year") 
    # theme(legend.position = "bottom")
  })
  
  # City
  output$city <- renderPlotly({
    number_of_cases_city <- 
      data_for_shiny_app |>
      # Group by city 
      group_by(city) |>
      # Count number of solved and unsolved homicides for each city
      count(arrest_was_not_made)|>
      # Rename count column
      rename(
        "num_of_cases_city" = n
      ) |>
      mutate(
        "proportion_of_cases" = round(num_of_cases_city/sum(num_of_cases_city), 2)
      ) |>
      mutate(
        arrest_was_not_made = case_when(
          (arrest_was_not_made == 1) ~ "Arrest was not made",
          (arrest_was_not_made == 0) ~ "Arrest was made",
          TRUE ~ "None")
      ) 
    
    number_of_cases_city |>
      ggplot(mapping = aes(x = arrest_was_not_made, y = proportion_of_cases)) +
      # Creates two graphs based on the status of the case
      facet_wrap(facets = vars(city)) +
      geom_bar(stat = "identity", fill = input$colour_of_graphs_main) +
      theme_minimal() +
      labs(x = "Status of the homicide case", y = "Proportion of cases") +
      theme(legend.position = "bottom")
  })
  
  # Disposition
  output$disposition <- renderPlotly({
    number_of_dispositions_city <- 
      data_for_shiny_app |>
      # Group by city 
      group_by(city) |>
      # Count number of dispositions for each city
      count(disposition)|>
      # Rename count column
      rename(
        "num_of_disposition_city" = n
      )
    
    number_of_dispositions_city |>
      ggplot(mapping = aes(x = disposition, y = num_of_disposition_city)) +
      # Creates two graphs based on the status of the case
      facet_wrap(facets = vars(city), dir = "v") +
      geom_bar(stat = "identity", fill = input$colour_of_graphs_main) +
      theme_minimal() +
      labs(x = "Disposition of homicide", y = "Number of cases") +
      theme(legend.position = "bottom")
  })
  
  # Victim's Age 
  output$victim_age <- renderPlotly({
    victim_age_dataframe <- 
      data_for_shiny_app |>
      # Group by age 
      group_by(victim_age) |>
      # Count number of solved and unsolved homicides by age
      count(arrest_was_not_made)|>
      # Rename count column
      rename(
        "num_of_cases" = n
      ) |>
      mutate(
        arrest_was_not_made = case_when(
          (arrest_was_not_made == 1) ~ "Arrest was not made",
          (arrest_was_not_made == 0) ~ "Arrest was made",
          TRUE ~ "None")
      ) 
    
    # Referenced Telling Stories with Data by Rohan Alexander 
    # for histogram code: 
    # https://tellingstorieswithdata.com/05-graphs_tables_maps.html#histograms
    victim_age_dataframe |>
      ggplot(aes(x = victim_age, fill = arrest_was_not_made)) +
      geom_histogram(position = "dodge", bins=input$number_of_bins) +
      theme_minimal() +
      scale_fill_manual(values=c(input$colour_of_graphs_main, 
                                 input$colour_of_graphs_secondary)) +
      labs(
        x = "Age of victim",
        y = "Number of cases",
        fill = "Status of homicide"
      ) +
      theme(legend.position = "bottom")
  })
  
  # Victim's Sex
  output$victim_sex <- renderPlotly({
    number_of_cases_victim_sex <- 
      data_for_shiny_app |>
      # Group by victim's sex 
      group_by(victim_sex) |>
      # Count number of solved and unsolved homicides for each sex
      count(arrest_was_not_made)|>
      # Rename count column
      rename(
        "num_of_cases_victim_sex" = n
      ) |>
      mutate(
        "proportion_of_cases" = 
          round(num_of_cases_victim_sex/sum(num_of_cases_victim_sex), 2)
      ) |>
      mutate(
        arrest_was_not_made = case_when(
          (arrest_was_not_made == 1) ~ "Arrest was not made",
          (arrest_was_not_made == 0) ~ "Arrest was made",
          TRUE ~ "None")
      ) 
    
    number_of_cases_victim_sex |>
      ggplot(mapping = aes(x = victim_sex, y = proportion_of_cases)) +
      # Creates two graphs based on the status of the case
      facet_wrap(facets = vars(arrest_was_not_made)) +
      geom_bar(stat = "identity", fill = input$colour_of_graphs_main) +
      theme_minimal() +
      labs(x = "Victim's Sex", y = "Proportion of cases") +
      theme(legend.position = "bottom")
  })
  
  # Victim's Race
  output$victim_race <- renderPlotly({
    number_of_cases_victim_race <- 
      data_for_shiny_app |>
      # Group by victim's race 
      group_by(victim_race) |>
      # Count number of solved and unsolved homicides for each race
      count(arrest_was_not_made)|>
      # Rename count column
      rename(
        "num_of_cases_victim_race" = n
      ) |>
      mutate(
        arrest_was_not_made = case_when(
          (arrest_was_not_made == 1) ~ "Arrest was not made",
          (arrest_was_not_made == 0) ~ "Arrest was made",
          TRUE ~ "None")
      ) 
    
    number_of_cases_victim_race |>
      ggplot(mapping = aes(x = victim_race, y = num_of_cases_victim_race)) +
      # Creates two graphs based on the status of the case
      facet_wrap(facets = vars(arrest_was_not_made)) +
      geom_bar(stat = "identity", fill = input$colour_of_graphs_main) +
      theme_minimal() +
      labs(x = "Victim's Race", y = "Number of cases") +
      theme(legend.position = "bottom")
  })
}

# Run the app
shinyApp(ui, server)