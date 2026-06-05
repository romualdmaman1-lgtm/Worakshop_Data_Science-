# build_data_dictionary.R
# Reads all 4 CSV files and prints summary info for the data dictionary.
# Run with: source("group_project/build_data_dictionary.R")

library(tidyverse)

# ── 1. Read all files ────────────────────────────────────────────────────

library(here)

base <- here::here("data", "group_a_yogurt")

sample_ids <- read_csv(file.path(base, "00_sample_ids_yogurt.csv"))
metadata   <- read_csv(file.path(base, "01_participant_metadata_yogurt.csv"))
qpcr       <- read_csv(file.path(base, "02_qpcr_results_yogurt.csv"))
luminex    <- read_csv(file.path(base, "03_luminex_results_yogurt.csv"))

files <- list(
  "00_sample_ids_yogurt.csv"        = sample_ids,
  "01_participant_metadata_yogurt.csv" = metadata,
  "02_qpcr_results_yogurt.csv"      = qpcr,
  "03_luminex_results_yogurt.csv"   = luminex
)

# ── 2. Helper: print a dictionary block for one file ────────────────────

describe_file <- function(df, file_name) {
  n_rows  <- nrow(df)
  n_cols  <- ncol(df)
  col_str <- str_c(names(df), collapse = ", ")

  cat("\n────────────────────────────────────────────────\n")
  cat("###", file_name, "\n")
  cat("**Rows:**", n_rows, "| **Columns:**", n_cols, "\n")
  cat("**Columns:**", col_str, "\n\n")

  # Print a mini table: column name, type, sample values, missing count
  tibble(
    column    = names(df),
    type      = map_chr(df, ~ str_c(class(.), collapse = "/")),
    sample    = map_chr(df, ~ {
      vals <- head(unique(.[!is.na(.)]), 4)
      str_c(vals, collapse = ", ")
    }),
    n_missing = map_int(df, ~ sum(is.na(.)))
  ) |>
    knitr::kable(format = "simple") |>
    print()
}

# ── 3. Print dictionary blocks ──────────────────────────────────────────

walk2(files, names(files), describe_file)

# ── 4. Cross-file checks ────────────────────────────────────────────────

cat("\n\n────────────────────────────────────────────────\n")
cat("## Cross-file checks\n")

# Do all sample_ids in qpcr/luminex exist in the sample_ids file?
missing_qpcr <- anti_join(qpcr, sample_ids, by = "sample_id")
missing_lum  <- anti_join(luminex, sample_ids, by = "sample_id")

cat("qpcr sample_ids not in sample_ids file:", nrow(missing_qpcr), "\n")
cat("luminex sample_ids not in sample_ids file:", nrow(missing_lum), "\n")

# Do all pids in sample_ids exist in metadata?
pids_in_samples <- distinct(sample_ids, pid)
missing_meta <- anti_join(pids_in_samples, metadata, by = "pid")
cat("pids in sample_ids but NOT in metadata:", nrow(missing_meta), "\n")

# Unique values for categorical columns (useful for the dictionary)
cat("\n**Study arms:**", unique(sample_ids$arm), "\n")
cat("**Time points:**", unique(sample_ids$time_point), "\n")
cat("**Cytokines measured:**", unique(luminex$cytokine), "\n")
cat("**Birth control types:**", unique(metadata$birth_control), "\n")
cat("**Education levels:**", unique(metadata$education), "\n")
cat("**Limits values:**", unique(luminex$limits), "\n")