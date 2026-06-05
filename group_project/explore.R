# Group A — Yogurt Study: Data Exploration
# Run this whole script with: source("group_project/explore.R")

library(tidyverse)

# Read all four CSV files
sample_ids <- read_csv("../data/group_a_yogurt/00_sample_ids_yogurt.csv")
metadata   <- read_csv("../data/group_a_yogurt/01_participant_metadata_yogurt.csv")
qpcr       <- read_csv("../data/group_a_yogurt/02_qpcr_results_yogurt.csv")
luminex    <- read_csv("../data/group_a_yogurt/03_luminex_results_yogurt.csv")

# Inspect each one
glimpse(sample_ids)
glimpse(metadata)
glimpse(qpcr)
glimpse(luminex)

# Counts
count(sample_ids, arm)
count(sample_ids, time_point)
count(luminex, cytokine)
summary(metadata$age)

# Join sample info onto lab results
qpcr_joined <- qpcr |>
  left_join(sample_ids, by = "sample_id")

luminex_joined <- luminex |>
  left_join(sample_ids, by = "sample_id")

# Quick plots
ggplot(qpcr_joined, aes(x = arm, y = qpcr_bacteria)) +
  geom_boxplot() +
  labs(title = "Total bacteria by study arm")

ggplot(qpcr_joined, aes(x = arm, y = qpcr_crispatus)) +
  geom_boxplot() +
  labs(title = "L. crispatus DNA by study arm")

luminex_joined |>
  filter(cytokine == "IL-1a") |>
  ggplot(aes(x = arm, y = conc)) +
  geom_boxplot() +
  labs(title = "IL-1a concentration by study arm")
