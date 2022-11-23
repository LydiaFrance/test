## ---------------------------
##
## Script name: Cleaning.r
##
## Purpose of script: 
##      Cleaning up the raw penguin data set by changing column names and removing columns. 
##
## Author: Dr. Lydia France
##
## Date Created: 2022-11-10
##
##
## ---------------------------
##
## Notes:
##   
##
## ---------------------------

# Clean column names, remove empty rows, remove columns called comment and delta
cleaning <- function(data_raw){
  data_raw %>%
    clean_names() %>%
    remove_empty(c("rows", "cols")) %>%
    select(-starts_with("delta")) %>%
    select(-comments)
}

# Subset the data to only include the penguins that are not NA for the bill length

remove_empty_flipper_length <- function(data_clean){
  data_clean %>%
    filter(!is.na(flipper_length_mm)) %>%
    select(species, flipper_length_mm)
}