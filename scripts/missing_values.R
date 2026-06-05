# Check for missing values (NAs) and "effectively missing" values
# (zeros that shouldn't be zero, constants, out-of-range flags, etc.)

library(dplyr)

cat("===============================================================\n")
cat("  PART 1: EXPLICIT NAs\n")
cat("===============================================================\n\n")

tables <- list(
  list(name = "sample_ids_yogurt",            path = "data/group_a_yogurt/00_sample_ids_yogurt.csv"),
  list(name = "participant_metadata_yogurt",  path = "data/group_a_yogurt/01_participant_metadata_yogurt.csv"),
  list(name = "qpcr_results_yogurt",          path = "data/group_a_yogurt/02_qpcr_results_yogurt.csv"),
  list(name = "luminex_yogurt",               path = "data/group_a_yogurt/03_luminex_results_yogurt.csv"),
  list(name = "sample_ids_period",            path = "data/group_b_menstruation/00_sample_ids_period.csv"),
  list(name = "participant_metadata_period",  path = "data/group_b_menstruation/01_participant_metadata_period.csv"),
  list(name = "luminex_period",               path = "data/group_b_menstruation/02_luminex_period.csv"),
  list(name = "flow_cytometry_period",        path = "data/group_b_menstruation/03_flow_cytometry_period.csv")
)

for (t in tables) {
  d <- read.csv(t$path)
  
  total_na <- sum(is.na(d))
  
  if (total_na == 0) {
    cat(sprintf("OK %s: NO missing values (NAs)\n", t$name))
  } else {
    cat(sprintf("MISSING %s: %d missing values total\n", t$name, total_na))
    for (col in names(d)) {
      na_count <- sum(is.na(d[[col]]))
      if (na_count > 0) {
        cat(sprintf("    %s: %d NAs (%.1f%%)\n", col, na_count, 100 * na_count / nrow(d)))
      }
    }
  }
}

cat("\n\n===============================================================\n")
cat("  PART 2: EFFECTIVELY MISSING VALUES\n")
cat("  Values that are not NA but are not real measurements either\n")
cat("===============================================================\n\n")

cat("-- qPCR zeros --\n")
qpcr <- read.csv("data/group_a_yogurt/02_qpcr_results_yogurt.csv")
for (col in c("qpcr_crispatus", "qpcr_iners")) {
  zeros <- sum(qpcr[[col]] == 0, na.rm = TRUE)
  cat(sprintf("  %s: %d zeros (%.0f%%) - likely means bacteria was NOT DETECTED, not truly 0\n",
              col, zeros, 100 * zeros / nrow(qpcr)))
}

cat("\n-- Luminex yogurt: 'out of range' flag --\n")
lum_yog <- read.csv("data/group_a_yogurt/03_luminex_results_yogurt.csv")
oor <- sum(lum_yog$limits == "out of range")
cat(sprintf("  %d of %d rows (%.0f%%) flagged as 'out of range'\n", oor, nrow(lum_yog), 100 * oor / nrow(lum_yog)))
cat("  These are measurements the lab said weren't reliable.\n")

cat("\n  Per cytokine:\n")
for (cyto in unique(lum_yog$cytokine)) {
  sub <- lum_yog[lum_yog$cytokine == cyto, ]
  oor_cyto <- sum(sub$limits == "out of range")
  cat(sprintf("    %s: %d/%.0f out of range (%.0f%%)\n", cyto, oor_cyto, nrow(sub), 100 * oor_cyto / nrow(sub)))
}

cat("\n-- Luminex yogurt: IL-10 constant check --\n")
il10 <- lum_yog[lum_yog$cytokine == "IL-10", ]
cat(sprintf("  IL-10 has %d measurements\n", nrow(il10)))
cat(sprintf("  Unique concentration values: %d\n", length(unique(il10$conc))))
cat(sprintf("  All values = %.4f\n", unique(il10$conc)))
cat(sprintf("  All flagged as: %s\n", unique(il10$limits)))
cat("  -> IL-10 was NEVER detected. Every value is a constant placeholder.\n")
cat("  -> These are effectively missing - you should exclude IL-10 from analysis.\n")

cat("\n-- Luminex menstruation: detection limits --\n")
lum_per <- read.csv("data/group_b_menstruation/02_luminex_period.csv")
bdl <- sum(lum_per$limits == "below_detection_limit")
adl <- sum(lum_per$limits == "above_detect_limit")
cat(sprintf("  Below detection limit: %d (%.0f%%)\n", bdl, 100 * bdl / nrow(lum_per)))
cat(sprintf("  Above detect limit:    %d (%.0f%%)\n", adl, 100 * adl / nrow(lum_per)))
cat(sprintf("  Not censored:          %d (%.0f%%)\n", 
    sum(lum_per$limits == "not_censored"), 
    100 * sum(lum_per$limits == "not_censored") / nrow(lum_per)))

cat("\n  Per cytokine:\n")
for (cyto in unique(lum_per$cytokine)) {
  sub <- lum_per[lum_per$cytokine == cyto, ]
  bdl_c <- sum(sub$limits == "below_detection_limit")
  adl_c <- sum(sub$limits == "above_detect_limit")
  cat(sprintf("    %s: %d below detection, %d above detection (of %d total)\n", cyto, bdl_c, adl_c, nrow(sub)))
}

cat("\n-- Flow cytometry: suspiciously low values --\n")
flow <- read.csv("data/group_b_menstruation/03_flow_cytometry_period.csv")
cat("  Lowest 5 values for each cell type:\n")
for (col in names(flow)[-1]) {
  sorted <- sort(flow[[col]])
  cat(sprintf("  %s: %s\n", col, paste(head(sorted, 5), collapse = ", ")))
}

cat("\n  Samples with cd4_t_cells < 100:\n")
low_cd4 <- flow[flow$cd4_t_cells < 100, ]
if (nrow(low_cd4) > 0) {
  print(low_cd4)
  cat(sprintf("  -> %d sample(s) with almost no CD4+ T cells detected\n", nrow(low_cd4)))
  cat("  -> This could be a failed sample (technical issue), not a real measurement\n")
}

cat("\n-- Empty strings in character columns --\n")
found_blanks <- FALSE
for (t in tables) {
  d <- read.csv(t$path, stringsAsFactors = FALSE)
  for (col in names(d)) {
    if (is.character(d[[col]])) {
      blanks <- sum(d[[col]] == "", na.rm = TRUE)
      if (blanks > 0) {
        cat(sprintf("  %s$%s: %d empty strings\n", t$name, col, blanks))
        found_blanks <- TRUE
      }
    }
  }
}
if (!found_blanks) cat("  (none found - clean dataset)\n")