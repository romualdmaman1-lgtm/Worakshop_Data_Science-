# Load the CSV files from both groups
# Group A — Yogurt study
sample_ids_yogurt     <- read.csv("data/group_a_yogurt/00_sample_ids_yogurt.csv")
participant_meta_yogurt <- read.csv("data/group_a_yogurt/01_participant_metadata_yogurt.csv")
qpcr_results_yogurt   <- read.csv("data/group_a_yogurt/02_qpcr_results_yogurt.csv")
luminex_yogurt        <- read.csv("data/group_a_yogurt/03_luminex_results_yogurt.csv")

# Group B — Menstruation study
sample_ids_period     <- read.csv("data/group_b_menstruation/00_sample_ids_period.csv")
participant_meta_period <- read.csv("data/group_b_menstruation/01_participant_metadata_period.csv")
luminex_period        <- read.csv("data/group_b_menstruation/02_luminex_period.csv")
flow_cytometry_period <- read.csv("data/group_b_menstruation/03_flow_cytometry_period.csv")

# ——— Quick summaries ———

cat("===== GROUP A — YOGURT =====\n\n")

cat("--- Sample IDs ---\n")
print(head(sample_ids_yogurt, 6))
cat(sprintf("Rows: %d\n\n", nrow(sample_ids_yogurt)))

cat("--- Participant Metadata ---\n")
print(head(participant_meta_yogurt, 6))
cat(sprintf("Rows: %d\n\n", nrow(participant_meta_yogurt)))

cat("--- qPCR Results ---\n")
print(head(qpcr_results_yogurt, 6))
cat(sprintf("Rows: %d\n\n", nrow(qpcr_results_yogurt)))

cat("--- Luminex Results ---\n")
print(head(luminex_yogurt, 6))
cat(sprintf("Rows: %d\n\n", nrow(luminex_yogurt)))

cat("===== GROUP B — MENSTRUATION =====\n\n")

cat("--- Sample IDs ---\n")
print(head(sample_ids_period, 6))
cat(sprintf("Rows: %d\n\n", nrow(sample_ids_period)))

cat("--- Participant Metadata ---\n")
print(head(participant_meta_period, 6))
cat(sprintf("Rows: %d\n\n", nrow(participant_meta_period)))

cat("--- Luminex Results ---\n")
print(head(luminex_period, 6))
cat(sprintf("Rows: %d\n\n", nrow(luminex_period)))

cat("--- Flow Cytometry Results ---\n")
print(head(flow_cytometry_period, 6))
cat(sprintf("Rows: %d\n\n", nrow(flow_cytometry_period)))