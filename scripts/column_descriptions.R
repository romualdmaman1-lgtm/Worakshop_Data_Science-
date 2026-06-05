# Examine all 8 tables: column types, values, and classifications

cat("═══════════════════════════════════════════════════════════\n")
cat("            TABLE 1: sample_ids_yogurt\n")
cat("═══════════════════════════════════════════════════════════\n")
d <- read.csv("data/group_a_yogurt/00_sample_ids_yogurt.csv")
cat(sprintf("Rows: %d  |  Unique pids: %d\n\n", nrow(d), length(unique(d$pid))))
for (col in names(d)) {
  cat(sprintf("── %s ──\n", col))
  cat(sprintf("   Type: %s\n", ifelse(is.numeric(d[[col]]), "NUMERIC", ifelse(is.character(d[[col]]), "CHARACTER / CATEGORICAL", typeof(d[[col]])))))
  cat(sprintf("   Unique values: %d\n", length(unique(d[[col]]))))
  if (length(unique(d[[col]])) <= 10) {
    cat(sprintf("   Values: %s\n", paste(sort(unique(d[[col]])), collapse = ", ")))
  } else {
    cat(sprintf("   First 6: %s\n", paste(head(unique(d[[col]])), collapse = ", ")))
  }
  cat("\n")
}

cat("═══════════════════════════════════════════════════════════\n")
cat("            TABLE 2: participant_metadata_yogurt\n")
cat("═══════════════════════════════════════════════════════════\n")
d <- read.csv("data/group_a_yogurt/01_participant_metadata_yogurt.csv")
cat(sprintf("Rows: %d  |  Unique pids: %d\n\n", nrow(d), length(unique(d$pid))))
for (col in names(d)) {
  cat(sprintf("── %s ──\n", col))
  cat(sprintf("   Type: %s\n", ifelse(is.numeric(d[[col]]), "NUMERIC", ifelse(is.character(d[[col]]), "CHARACTER / CATEGORICAL", typeof(d[[col]])))))
  cat(sprintf("   Unique values: %d\n", length(unique(d[[col]]))))
  if (length(unique(d[[col]])) <= 12) {
    cat(sprintf("   Values: %s\n", paste(sort(unique(d[[col]])), collapse = ", ")))
  } else {
    cat(sprintf("   First 8: %s\n", paste(head(unique(d[[col]]), 8), collapse = ", ")))
  }
  cat("\n")
}

cat("═══════════════════════════════════════════════════════════\n")
cat("            TABLE 3: qpcr_results_yogurt\n")
cat("═══════════════════════════════════════════════════════════\n")
d <- read.csv("data/group_a_yogurt/02_qpcr_results_yogurt.csv")
cat(sprintf("Rows: %d\n\n", nrow(d)))
for (col in names(d)) {
  cat(sprintf("── %s ──\n", col))
  cat(sprintf("   Type: %s\n", ifelse(is.numeric(d[[col]]), "NUMERIC", ifelse(is.character(d[[col]]), "CHARACTER / CATEGORICAL", typeof(d[[col]])))))
  cat(sprintf("   Unique values: %d\n", length(unique(d[[col]]))))
  if (is.numeric(d[[col]])) {
    cat(sprintf("   Range: %.2f to %.2f\n", min(d[[col]], na.rm = TRUE), max(d[[col]], na.rm = TRUE)))
  }
  cat("\n")
}

cat("═══════════════════════════════════════════════════════════\n")
cat("            TABLE 4: luminex_yogurt\n")
cat("═══════════════════════════════════════════════════════════\n")
d <- read.csv("data/group_a_yogurt/03_luminex_results_yogurt.csv")
cat(sprintf("Rows: %d\n\n", nrow(d)))
for (col in names(d)) {
  cat(sprintf("── %s ──\n", col))
  cat(sprintf("   Type: %s\n", ifelse(is.numeric(d[[col]]), "NUMERIC", ifelse(is.character(d[[col]]), "CHARACTER / CATEGORICAL", typeof(d[[col]])))))
  cat(sprintf("   Unique values: %d\n", length(unique(d[[col]]))))
  if (length(unique(d[[col]])) <= 10) {
    cat(sprintf("   Values: %s\n", paste(sort(unique(d[[col]])), collapse = ", ")))
  }
  cat("\n")
}

cat("═══════════════════════════════════════════════════════════\n")
cat("            TABLE 5: sample_ids_period\n")
cat("═══════════════════════════════════════════════════════════\n")
d <- read.csv("data/group_b_menstruation/00_sample_ids_period.csv")
cat(sprintf("Rows: %d  |  Unique pids: %d\n\n", nrow(d), length(unique(d$pid))))
for (col in names(d)) {
  cat(sprintf("── %s ──\n", col))
  cat(sprintf("   Type: %s\n", ifelse(is.numeric(d[[col]]), "NUMERIC", ifelse(is.character(d[[col]]), "CHARACTER / CATEGORICAL", typeof(d[[col]])))))
  cat(sprintf("   Unique values: %d\n", length(unique(d[[col]]))))
  if (length(unique(d[[col]])) <= 10) {
    cat(sprintf("   Values: %s\n", paste(sort(unique(d[[col]])), collapse = ", ")))
  } else {
    cat(sprintf("   First 6: %s\n", paste(head(unique(d[[col]])), collapse = ", ")))
  }
  cat("\n")
}

cat("═══════════════════════════════════════════════════════════\n")
cat("            TABLE 6: participant_metadata_period\n")
cat("═══════════════════════════════════════════════════════════\n")
d <- read.csv("data/group_b_menstruation/01_participant_metadata_period.csv")
cat(sprintf("Rows: %d  |  Unique pids: %d\n\n", nrow(d), length(unique(d$pid))))
for (col in names(d)) {
  cat(sprintf("── %s ──\n", col))
  cat(sprintf("   Type: %s\n", ifelse(is.numeric(d[[col]]), "NUMERIC", ifelse(is.character(d[[col]]), "CHARACTER / CATEGORICAL", typeof(d[[col]])))))
  cat(sprintf("   Unique values: %d\n", length(unique(d[[col]]))))
  if (length(unique(d[[col]])) <= 10) {
    cat(sprintf("   Values: %s\n", paste(sort(unique(d[[col]])), collapse = ", ")))
  }
  cat("\n")
}

cat("═══════════════════════════════════════════════════════════\n")
cat("            TABLE 7: luminex_period\n")
cat("═══════════════════════════════════════════════════════════\n")
d <- read.csv("data/group_b_menstruation/02_luminex_period.csv")
cat(sprintf("Rows: %d\n\n", nrow(d)))
for (col in names(d)) {
  cat(sprintf("── %s ──\n", col))
  cat(sprintf("   Type: %s\n", ifelse(is.numeric(d[[col]]), "NUMERIC", ifelse(is.character(d[[col]]), "CHARACTER / CATEGORICAL", typeof(d[[col]])))))
  cat(sprintf("   Unique values: %d\n", length(unique(d[[col]]))))
  if (length(unique(d[[col]])) <= 10) {
    cat(sprintf("   Values: %s\n", paste(sort(unique(d[[col]])), collapse = ", ")))
  }
  cat("\n")
}

cat("═══════════════════════════════════════════════════════════\n")
cat("            TABLE 8: flow_cytometry_period\n")
cat("═══════════════════════════════════════════════════════════\n")
d <- read.csv("data/group_b_menstruation/03_flow_cytometry_period.csv")
cat(sprintf("Rows: %d\n\n", nrow(d)))
for (col in names(d)) {
  cat(sprintf("── %s ──\n", col))
  cat(sprintf("   Type: %s\n", ifelse(is.numeric(d[[col]]), "NUMERIC", ifelse(is.character(d[[col]]), "CHARACTER / CATEGORICAL", typeof(d[[col]])))))
  cat(sprintf("   Unique values: %d\n", length(unique(d[[col]]))))
  if (is.numeric(d[[col]])) {
    cat(sprintf("   Range: %.2f to %.2f\n", min(d[[col]], na.rm = TRUE), max(d[[col]], na.rm = TRUE)))
  }
  cat("\n")
}