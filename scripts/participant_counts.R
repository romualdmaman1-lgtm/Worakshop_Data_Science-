# Count participants and observations per participant

cat("════════════════════════════════════════════\n")
cat("  GROUP A — YOGURT\n")
cat("════════════════════════════════════════════\n\n")

sids_yog <- read.csv("data/group_a_yogurt/00_sample_ids_yogurt.csv")
meta_yog <- read.csv("data/group_a_yogurt/01_participant_metadata_yogurt.csv")
qpcr_yog <- read.csv("data/group_a_yogurt/02_qpcr_results_yogurt.csv")
lum_yog  <- read.csv("data/group_a_yogurt/03_luminex_results_yogurt.csv")

cat(sprintf("Participants: %d\n", nrow(meta_yog)))
cat(sprintf("Total samples: %d\n", nrow(sids_yog)))

cat("\nSamples per participant:\n")
samples_per_pid <- table(sids_yog$pid)
print(table(samples_per_pid))
cat(sprintf("  → All participants have %d samples (%s)\n", 
    unique(samples_per_pid), 
    paste(names(samples_per_pid), collapse = ", ")))

cat("\nSamples by time point:\n")
print(table(sids_yog$time_point))

cat("\nSamples per participant per time point:\n")
print(table(sids_yog$pid, sids_yog$time_point))

cat("\nObservations in qPCR (wide format):\n")
cat(sprintf("  %d rows = 1 per sample → %d per participant\n", nrow(qpcr_yog), nrow(qpcr_yog)/nrow(meta_yog)))

cat("\nObservations in Luminex (long format):\n")
cat(sprintf("  %d rows = ~%.1f per sample = ~%.1f per participant\n", 
    nrow(lum_yog), nrow(lum_yog)/nrow(sids_yog), nrow(lum_yog)/nrow(meta_yog)))
cytokines_yog <- unique(lum_yog$cytokine)
cat(sprintf("  (%d cytokines measured per sample)\n", length(cytokines_yog)))

cat("\n\n════════════════════════════════════════════\n")
cat("  GROUP B — MENSTRUATION\n")
cat("════════════════════════════════════════════\n\n")

sids_per <- read.csv("data/group_b_menstruation/00_sample_ids_period.csv")
meta_per <- read.csv("data/group_b_menstruation/01_participant_metadata_period.csv")
lum_per  <- read.csv("data/group_b_menstruation/02_luminex_period.csv")
flow_per <- read.csv("data/group_b_menstruation/03_flow_cytometry_period.csv")

cat(sprintf("Participants: %d\n", nrow(meta_per)))
cat(sprintf("Total samples: %d\n", nrow(sids_per)))

cat("\nSamples per participant:\n")
samples_per_pid_per <- table(sids_per$pid)
print(table(samples_per_pid_per))
cat(sprintf("  → Range: %d to %d samples per participant\n", min(samples_per_pid_per), max(samples_per_pid_per)))

cat("\nSamples by time point:\n")
print(table(sids_per$time_point))

cat("\nObservations in flow cytometry (wide format):\n")
cat(sprintf("  %d rows = 1 per sample → ~%.1f per participant\n", nrow(flow_per), nrow(flow_per)/nrow(meta_per)))

cat("\nObservations in Luminex (long format):\n")
cat(sprintf("  %d rows = ~%.1f per sample = ~%.1f per participant\n", 
    nrow(lum_per), nrow(lum_per)/nrow(sids_per), nrow(lum_per)/nrow(meta_per)))
cytokines_per <- unique(lum_per$cytokine)
cat(sprintf("  (%d cytokines measured per sample)\n", length(cytokines_per)))