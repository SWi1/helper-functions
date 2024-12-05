# IMPORT AND MERGE NANODROP EXPORT CSV FILES
# Stephanie Wilson, November 2024

# SUMMARY
# This script imports the csv files exported from the Nanodrop 
# and merges them into a singular file.
# Output: merged_data with all collumns

# USAGE
# Load the function from GitHub
# source("https://raw.githubusercontent.com/SWi1/helper-functions/main/functions/import_nanodrop.R")

# Set path to directory where files are stored
# wd = "/path/to/folder/withNanodropfiles"

# Create list of csv export files
# exportlist = list.files(wd, pattern = "*.csv", full.names = TRUE)

# Function Usage
# Save output to object
# merged_data = import_nanodrop(exportlist)


import_nanodrop <- function(file_list) {
  library(readr)
  library(dplyr)
  library(purrr)
  library(stringr)
  
  # Step 1: Generate clean names based on the file names
  clean_names <- file_list %>%
    map_chr(~ {
      date_str <- str_extract(basename(.x), "\\d{1,2}_\\d{1,2}_\\d{4}")
      paste0("results_", date_str)
    })
  
  # Step 2: Read files and store in a named list
  datasets <- map2(file_list, clean_names, ~ {
    suppressMessages(
      suppressWarnings(
        read_delim(.x, delim = "\t", locale = locale(encoding = "UTF-16LE"))
      )
    )
  })
  
  # Step 3: Standardize column types
  standardized_datasets <- datasets %>%
    map(~ as_tibble(.) %>% mutate_all(as.character))
  
  # Step 4: Combine all datasets into one
  merged_data <- bind_rows(standardized_datasets)
  
  return(merged_data)
}
