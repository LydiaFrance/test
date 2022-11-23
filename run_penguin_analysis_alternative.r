## ---------------------------
##
## Script name: run_penguin_analysis.r
##
## Purpose of script: 
##      Loads penguin data, cleans it, and plots the flipper length, 
##      and saves the plot to a file.
##
## Author: Dr. Lydia France
##
## Date Created: 2022-11-06
##
##
## Notes:
##   
##
## ---------------------------

# Load the packages

library(palmerpenguins)
library(ggplot2)
suppressPackageStartupMessages(library(janitor))
suppressPackageStartupMessages(library(dplyr))
library(tidyr)
library(ragg)
library(svglite)

# Set working directory 

setwd("/Users/lfrance/Documents/R_teaching/PenguinProject/")

# ----------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------

# ---------------------------
# Define Functions
# ---------------------------

# ---- Cleaning --------------

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

# ---- Plots --------------

# Plot the flipper length as a boxplot of species
plot_flipper_figure <- function(penguins_flippers){
  penguins_flippers %>% 
    ggplot(aes(x = species, y = flipper_length_mm)) +
    geom_boxplot(aes(color = species), width = 0.3, show.legend = FALSE) +
    geom_jitter(aes(color = species), alpha = 0.3, show.legend = FALSE, 
                position = position_jitter(width = 0.2, seed = 0)) +
    scale_color_manual(values = c("darkorange","purple","cyan4")) +
    scale_x_discrete(labels=c("Adelie","Chinstrap","Gentoo")) +
    labs(x = "Penguin Species",
         y = "Flipper length (mm)") +
    theme_bw()
}

# ---- Saving --------------

# Save the plot as a png and define the size, resolution, and scaling
save_flipper_plot_png <- function(penguins_flippers, filename, size, res, scaling){
  agg_png(filename, width = size, 
                    height = size, 
                    units = "cm", 
                    res = res, 
                    scaling = scaling)
  flipper_box <- plot_flipper_figure(penguins_flippers)
  print(flipper_box)
  dev.off()
}

# Save the plot as a svg and define the size and scaling
save_flipper_plot_svg <- function(penguins_flippers, filename, size, scaling){
    size_inches = size/2.54
    svglite(filename, width = size_inches, height = size_inches, scaling = scaling)
    flipper_box <- plot_flipper_figure(penguins_flippers)
    print(flipper_box)
    dev.off()
}

# ----------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------

# ---------------------------
# Load the data
# ---------------------------

penguins_raw <- read.csv("data_raw/penguins_raw.csv")

# ---------------------------
# Clean the data
# ---------------------------

# Fix the column names, remove empty rows, remove columns called comment and delta
penguins_clean <- cleaning(penguins_raw)

# Save the cleaned data
write.csv(penguins_clean, "data_clean/penguins_clean.csv")

# Subset the data and remove the penguins with NA flipper length
penguins_flippers <- remove_empty_flipper_length(penguins_clean)


# ---------------------------
# Plot the data
# ---------------------------

# Plot the flipper length as a boxplot of species
flipper_boxplot <- plot_flipper_figure(penguins_flippers)


# ---------------------------
# Save Figures
# ---------------------------


# Save the plot for a report
save_flipper_plot_png(penguins_flippers, "figures/fig01_report.png", 
                      size = 15, res = 600, scaling = 1)

# Save the plot for a presentation
save_flipper_plot_png(penguins_flippers, "figures/fig01_powerpoint.png", 
                      size = 15, res = 600, scaling = 1.4)

# Save the plot for a poster
save_flipper_plot_png(penguins_flippers, "figures/fig01_poster.png", 
                      size = 30, res = 600, scaling = 2.8)

# Save the plot as a vector (no resolution needed)
save_flipper_plot_svg(penguins_flippers, "figures/fig01_vector.svg", 
                      size = 15, scaling = 1)
