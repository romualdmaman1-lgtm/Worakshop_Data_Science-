# Examine distributions of all numeric variables — skewness, outliers, suspicious values

library(dplyr)

cat("═══════════════════════════════════════════════════════════\n")
cat("  GROUP A — YOGURT\n")
cat("═══════════════════════════════════════════════════════════\n")

meta_yog <- read.csv("data/group_a_yogurt/01_participant_metadata_yogurt.csv")
qpcr_yog <- read.csv("data/group_a_yogurt/02_qpcr_results_yogurt.csv")
lum_yog  <- read.csv("data/group_a_yogurt/03_luminex_results_yogurt.csv")

cat("\n── participant_metadata_yogurt ──\n")
for (col in c("age", "days_since_last_sex")) {
  x <- meta_yog[[col]]
  cat(sprintf("\n  %s:\n", col))
  cat(sprintf("    Min: %.1f  |  Q1: %.1f  |  Median: %.1f  |  Mean: %.1f  |  Q3: %.1f  |  Max: %.1f\n",
              min(x), quantile(x, 0.25), median(x), mean(x), quantile(x, 0.75), max(x)))
  cat(sprintf("    SD: %.2f  |  IQR: %.1f\n", sd(x), IQR(x)))
  
  # Skewness (rough estimate: (mean - median) / sd)
  skew <- (mean(x) - median(x)) / sd(x)
  cat(sprintf("    Skew indicator (mean-median)/sd: %.3f %s\n", skew,
              ifelse(abs(skew) > 0.5, "← ⚠️ mod/heavy skew", "")))
  
  # Check for impossible/weird values
  if (col == "age") {
    if (any(x < 0 | x > 120)) cat("    ⚠️ IMPOSSIBLE age value found!\n")
  }
  if (col == "days_since_last_sex") {
    if (any(x < 0)) cat("    ⚠️ Negative days! Suspicious.\n")
    cat(sprintf("    Unique values: %d\n", length(unique(x))))
    cat(sprintf("    Value counts: %s\n", paste(sort(table(x))[1:3], collapse = ", "), " (top 3 lowest counts)"))
  }
  
  # Check for zero / weird concentrations
  zeros <- sum(x == 0, na.rm = TRUE)
  if (zeros > 0) cat(sprintf("    Zeros: %d (%.0f%% of values)\n", zeros, 100*zeros/length(x)))
}

cat("\n── qpcr_results_yogurt ──\n")
for (col in c("qpcr_bacteria", "qpcr_crispatus", "qpcr_iners")) {
  x <- qpcr_yog[[col]]
  cat(sprintf("\n  %s:\n", col))
  cat(sprintf("    Min: %.2f  |  Q1: %.2f  |  Median: %.2f  |  Mean: %.2f  |  Q3: %.2f  |  Max: %.2f\n",
              min(x), quantile(x, 0.25), median(x), mean(x), quantile(x, 0.75), max(x)))
  sd_val <- sd(x)
  cat(sprintf("    SD: %.2f  |  IQR: %.2f\n", sd_val, IQR(x)))
  skew <- (mean(x) - median(x)) / sd_val
  cat(sprintf("    Skew indicator (mean-median)/sd: %.3f %s\n", skew,
              ifelse(abs(skew) > 0.5, "← ⚠️ mod/heavy skew", "")))
  
  zeros <- sum(x == 0, na.rm = TRUE)
  if (zeros > 0) cat(sprintf("    Zeros: %d (%.0f%% of values)\n", zeros, 100*zeros/length(x)))
  
  # Check for values that are suspiciously high (potential outliers)
  Q3 <- quantile(x, 0.75)
  IQR_val <- IQR(x)
  upper_fence <- Q3 + 3 * IQR_val
  extreme <- sum(x > upper_fence, na.rm = TRUE)
  if (extreme > 0) {
    cat(sprintf("    Values > 3×IQR above Q3: %d (%.0f%%)\n", extreme, 100*extreme/length(x)))
    cat(sprintf("    3×IQR upper fence: %.2f\n", upper_fence))
    cat(sprintf("    Max is %.1f × the median\n", max(x)/median(x)))
  }
}

cat("\n── luminex_yogurt (conc) ──\n")
x <- lum_yog$conc
cat(sprintf("    Min: %.4f  |  Q1: %.4f  |  Median: %.4f  |  Mean: %.4f  |  Q3: %.4f  |  Max: %.4f\n",
            min(x), quantile(x, 0.25), median(x), mean(x), quantile(x, 0.75), max(x)))
sd_val <- sd(x)
cat(sprintf("    SD: %.4f  |  IQR: %.4f\n", sd_val, IQR(x)))
skew <- (mean(x) - median(x)) / sd_val
cat(sprintf("    Skew indicator (mean-median)/sd: %.3f %s\n", skew,
            ifelse(abs(skew) > 0.5, "← ⚠️ mod/heavy skew", "")))
zeros <- sum(x == 0, na.rm = TRUE)
if (zeros > 0) cat(sprintf("    Zeros: %d\n", zeros))
cat(sprintf("    Negative values: %d\n", sum(x < 0, na.rm = TRUE)))

# Luminex by cytokine
cat("\n  Luminex conc by cytokine:\n")
for (cyto in unique(lum_yog$cytokine)) {
  sub <- lum_yog$conc[lum_yog$cytokine == cyto]
  cat(sprintf("\n    %s: median = %.4f, mean = %.4f, max = %.4f", cyto, median(sub), mean(sub), max(sub)))
}

# Check limits distribution
cat("\n\n  Limits distribution:\n")
print(table(lum_yog$limits))


cat("\n\n═══════════════════════════════════════════════════════════\n")
cat("  GROUP B — MENSTRUATION\n")
cat("═══════════════════════════════════════════════════════════\n")

meta_per <- read.csv("data/group_b_menstruation/01_participant_metadata_period.csv")
flow_per <- read.csv("data/group_b_menstruation/03_flow_cytometry_period.csv")
lum_per  <- read.csv("data/group_b_menstruation/02_luminex_period.csv")

cat("\n── participant_metadata_period ──\n")
x <- meta_per$age
cat(sprintf("\n  age:\n"))
cat(sprintf("    Min: %.1f  |  Q1: %.1f  |  Median: %.1f  |  Mean: %.1f  |  Q3: %.1f  |  Max: %.1f\n",
            min(x), quantile(x, 0.25), median(x), mean(x), quantile(x, 0.75), max(x)))
cat(sprintf("    SD: %.2f\n", sd(x)))
if (any(x < 0 | x > 120)) cat("    ⚠️ IMPOSSIBLE age value found!\n")

cat("\n── flow_cytometry_period ──\n")
for (col in names(flow_per)[-1]) {
  x <- flow_per[[col]]
  cat(sprintf("\n  %s:\n", col))
  cat(sprintf("    Min: %.0f  |  Q1: %.0f  |  Median: %.0f  |  Mean: %.0f  |  Q3: %.0f  |  Max: %.0f\n",
              min(x), quantile(x, 0.25), median(x), mean(x), quantile(x, 0.75), max(x)))
  sd_val <- sd(x)
  cat(sprintf("    SD: %.0f  |  IQR: %.0f\n", sd_val, IQR(x)))
  skew <- (mean(x) - median(x)) / sd_val
  cat(sprintf("    Skew indicator (mean-median)/sd: %.3f %s\n", skew,
              ifelse(abs(skew) > 0.5, "← ⚠️ mod/heavy skew", "")))
  
  zeros <- sum(x == 0, na.rm = TRUE)
  if (zeros > 0) cat(sprintf("    Zeros: %d\n", zeros))
  
  Q3 <- quantile(x, 0.75)
  IQR_val <- IQR(x)
  upper_fence <- Q3 + 3 * IQR_val
  extreme <- sum(x > upper_fence, na.rm = TRUE)
  if (extreme > 0) {
    cat(sprintf("    Values > 3×IQR above Q3: %d (%.0f%%)\n", extreme, 100*extreme/length(x)))
  }
  # Spread ratio
  cat(sprintf("    Max/min ratio: %.0f\n", max(x)/min(x)))
}

cat("\n── luminex_period (conc) ──\n")
x <- lum_per$conc
cat(sprintf("    Min: %.4f  |  Q1: %.4f  |  Median: %.4f  |  Mean: %.4f  |  Q3: %.4f  |  Max: %.4f\n",
            min(x), quantile(x, 0.25), median(x), mean(x), quantile(x, 0.75), max(x)))
sd_val <- sd(x)
cat(sprintf("    SD: %.4f  |  IQR: %.4f\n", sd_val, IQR(x)))
skew <- (mean(x) - median(x)) / sd_val
cat(sprintf("    Skew indicator (mean-median)/sd: %.3f %s\n", skew,
            ifelse(abs(skew) > 0.5, "← ⚠️ mod/heavy skew", "")))
zeros <- sum(x == 0, na.rm = TRUE)
if (zeros > 0) cat(sprintf("    Zeros: %d\n", zeros))
cat(sprintf("    Negative values: %d\n", sum(x < 0, na.rm = TRUE)))

cat("\n  Luminex conc by cytokine:\n")
for (cyto in unique(lum_per$cytokine)) {
  sub <- lum_per$conc[lum_per$cytokine == cyto]
  cat(sprintf("\n    %s: median = %.4f, mean = %.4f, max = %.4f", cyto, median(sub), mean(sub), max(sub)))
}

cat("\n\n  Limits distribution:\n")
print(table(lum_per$limits))