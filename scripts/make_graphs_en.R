library(tidyverse)
library(ggpubr)

donnees <- read_tsv("data/etude_mere_enfant.csv", na = c("", "NA", "f"), show_col_types = FALSE)
donnees <- donnees %>%
  mutate(`CMV cord` = as.numeric(`CMV cord`),
         Howmanylivingchildrendoyouhave = as.numeric(Howmanylivingchildrendoyouhave),
         parite_cat = case_when(
           HowmanydeliverieshaveyouhadintotalParity <= 1 ~ "Primiparous",
           HowmanydeliverieshaveyouhadintotalParity <= 3 ~ "Multiparous",
           TRUE ~ "Grand multiparous"),
         poids_cat = case_when(
           `Birth weigh (tg)` < 2500 ~ "Low birth weight (< 2.5kg)",
           `Birth weigh (tg)` <= 4000 ~ "Normal (2.5-4kg)",
           TRUE ~ "Macrosomic (> 4kg)"))

couleurs <- c("F" = "#E8829A", "M" = "#4E9BBF")

# Graph 1: sCD14 by HIV
p1 <- ggplot(donnees, aes(x = `HIV STATUS`, y = `sCD14 [ng/ml]`, fill = `HIV STATUS`)) +
  geom_boxplot() + geom_jitter(alpha = 0.3, width = 0.2) +
  stat_compare_means(method = "t.test", label.x = 1.3, label = "p.format") +
  labs(title = "Inflammation (sCD14) by HIV Status",
       subtitle = "p < 0.001 - HIV+ associated with higher inflammation",
       x = "HIV Status", y = "sCD14 (ng/ml)") +
  theme_minimal() + scale_fill_manual(values = c("Negative" = "#2E86AB", "Positive" = "#A23B72"))
ggsave("notebooks/graph1_scd14_vih.png", p1, width = 6, height = 4)

# Graph 2: Transfer ratios
ratios_long <- donnees %>%
  pivot_longer(cols = c("ratio CMV", "ratio RSV", "ratio ENTERO", "ratio TT"),
               names_to = "virus", values_to = "ratio") %>%
  mutate(virus = recode(virus, "ratio CMV" = "CMV", "ratio RSV" = "RSV",
                        "ratio ENTERO" = "Enterovirus", "ratio TT" = "TT"))

p2 <- ggplot(ratios_long, aes(x = virus, y = ratio, fill = virus)) +
  geom_boxplot() +
  geom_hline(yintercept = 1, linetype = "dashed", color = "red", size = 1) +
  annotate("text", x = 4.5, y = 1.1, label = "Efficient transfer (ratio > 1)", color = "red", hjust = 1) +
  scale_y_log10() +
  labs(title = "Mother-to-cord transfer ratios",
       subtitle = "RSV and Enterovirus: highly efficient. TT: poor transfer",
       x = "", y = "Ratio (cord / mother) - log scale") +
  theme_minimal()
ggsave("notebooks/graph2_ratios_transfert.png", p2, width = 7, height = 5)

# Graph 3: % efficient transfer
pct_data <- data.frame(virus = c("CMV", "RSV", "Enterovirus", "TT"), pct = c(56.6, 100, 83.6, 22.4))
p3 <- ggplot(pct_data, aes(x = reorder(virus, pct), y = pct, fill = virus)) +
  geom_col() + geom_text(aes(label = sprintf("%.1f%%", pct)), vjust = -0.5) +
  labs(title = "Proportion of efficient transfers (ratio > 1)",
       x = "", y = "% of participants") +
  theme_minimal() + ylim(0, 110)
ggsave("notebooks/graph3_pct_efficace.png", p3, width = 6, height = 4)

# Graph 4: Ratios by parity
p4 <- ggplot(ratios_long %>% filter(!is.na(parite_cat)), 
             aes(x = parite_cat, y = ratio, fill = parite_cat)) +
  geom_boxplot() + geom_hline(yintercept = 1, linetype = "dashed", color = "red", alpha = 0.5) +
  facet_wrap(~virus, scales = "free_y") + scale_y_log10() +
  labs(title = "Transfer ratio by parity",
       subtitle = "Little difference across parity groups",
       x = "", y = "Ratio (log)") +
  theme_minimal() + theme(legend.position = "none")
ggsave("notebooks/graph4_ratio_parite.png", p4, width = 8, height = 6)

# Graph 5: Birth weight vs ratio
p5 <- ggplot(ratios_long, aes(x = `Birth weigh (tg)`, y = ratio, color = virus)) +
  geom_point(alpha = 0.5) + geom_hline(yintercept = 1, linetype = "dashed", color = "red", alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE) + facet_wrap(~virus, scales = "free_y") + scale_y_log10() +
  labs(title = "Transfer ratio vs birth weight",
       subtitle = "Very weak correlations (|r| < 0.09)",
       x = "Birth weight (g)", y = "Ratio (log)") +
  theme_minimal()
ggsave("notebooks/graph5_poids_ratio.png", p5, width = 8, height = 6)

# Graph 6: Ratios by sex, faceted by HIV
# Compute positions for manual p-value annotations (only significant panels)
p_annot <- data.frame(
  virus = c("CMV", "TT"),
  `HIV STATUS` = c("Negative", "Negative"),
  y_pos = c(190, 160),
  label = c("p = 0.013", "p = 0.017"),
  check.names = FALSE
)

p6 <- ggplot(ratios_long %>% filter(!is.na(`child SEX`)), 
             aes(x = `child SEX`, y = ratio, fill = `child SEX`)) +
  geom_boxplot() + geom_jitter(alpha = 0.3, width = 0.15) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "red", alpha = 0.5) +
  geom_text(data = p_annot, aes(x = 1.5, y = y_pos, label = label),
            inherit.aes = FALSE, size = 3.5) +
  facet_grid(virus ~ `HIV STATUS`, scales = "free_y") + scale_y_log10() +
  scale_fill_manual(values = couleurs) +
  labs(title = "Transfer ratios by child sex and HIV status",
       x = "Child sex", y = "Ratio (cord/mother) - log scale") +
  theme_minimal() + theme(legend.position = "none")
ggsave("notebooks/graph_sexe_ratios.png", p6, width = 8, height = 8)

# Graph 7: % efficient by sex and HIV
pct_data2 <- donnees %>%
  filter(!is.na(`child SEX`)) %>%
  pivot_longer(cols = c("ratio CMV", "ratio RSV", "ratio ENTERO", "ratio TT"),
               names_to = "virus", values_to = "ratio") %>%
  mutate(virus = recode(virus, "ratio CMV" = "CMV", "ratio RSV" = "RSV",
                        "ratio ENTERO" = "Enterovirus", "ratio TT" = "TT")) %>%
  group_by(`HIV STATUS`, `child SEX`, virus) %>%
  summarise(n_total = sum(!is.na(ratio)), n_efficace = sum(ratio > 1, na.rm = TRUE),
            pct = 100 * n_efficace / n_total, .groups = "drop")

p7 <- ggplot(pct_data2, aes(x = `child SEX`, y = pct, fill = `child SEX`)) +
  geom_col(position = "dodge") + geom_text(aes(label = sprintf("%.0f%%", pct)), vjust = -0.5, size = 3.5) +
  facet_grid(virus ~ `HIV STATUS`) + scale_fill_manual(values = couleurs) + ylim(0, 115) +
  labs(title = "% efficient transfer by child sex and HIV status",
       x = "Child sex", y = "% efficient transfer") +
  theme_minimal() + theme(legend.position = "none")
ggsave("notebooks/graph_sexe_pct_efficace.png", p7, width = 8, height = 7)

# Graph 8: sCD14 by sex and HIV
p8 <- ggplot(donnees %>% filter(!is.na(`child SEX`)), 
             aes(x = `child SEX`, y = `sCD14 [ng/ml]`, fill = `child SEX`)) +
  geom_boxplot() + geom_jitter(alpha = 0.3, width = 0.15) +
  facet_wrap(~`HIV STATUS`) + scale_fill_manual(values = couleurs) +
  labs(title = "Inflammation (sCD14) by child sex and HIV status",
       x = "Child sex", y = "sCD14 (ng/ml)") +
  theme_minimal() + theme(legend.position = "none")
ggsave("notebooks/graph_sexe_scd14.png", p8, width = 7, height = 5)

# Graph 9: IFABP by sex and HIV
p9 <- ggplot(donnees %>% filter(!is.na(`child SEX`)), 
             aes(x = `child SEX`, y = `IFABP [pg/ml]`, fill = `child SEX`)) +
  geom_boxplot() + geom_jitter(alpha = 0.3, width = 0.15) +
  facet_wrap(~`HIV STATUS`) + scale_fill_manual(values = couleurs) +
  coord_cartesian(ylim = c(0, 5000)) +
  labs(title = "Intestinal permeability (IFABP) by child sex and HIV",
       x = "Child sex", y = "IFABP (pg/ml)") +
  theme_minimal() + theme(legend.position = "none")
ggsave("notebooks/graph_sexe_ifabp.png", p9, width = 7, height = 5)

# Graph 10: Birth weight by sex and HIV
p10 <- ggplot(donnees %>% filter(!is.na(`child SEX`)), 
              aes(x = `child SEX`, y = `Birth weigh (tg)`, fill = `child SEX`)) +
  geom_boxplot() + geom_jitter(alpha = 0.3, width = 0.15) +
  facet_wrap(~`HIV STATUS`) + scale_fill_manual(values = couleurs) +
  labs(title = "Birth weight by child sex and HIV status",
       x = "Child sex", y = "Birth weight (g)") +
  theme_minimal() + theme(legend.position = "none")
ggsave("notebooks/graph_sexe_poids.png", p10, width = 7, height = 5)

# Graph 11: Parity by sex and HIV
p11 <- ggplot(donnees %>% filter(!is.na(`child SEX`)), 
              aes(x = `child SEX`, fill = parite_cat)) +
  geom_bar(position = "fill") + facet_wrap(~`HIV STATUS`) +
  scale_fill_manual(values = c("Primiparous" = "#FDE74C", "Multiparous" = "#9BC53D", 
                                "Grand multiparous" = "#C3423F")) +
  labs(title = "Parity distribution by child sex and HIV",
       x = "Child sex", y = "Proportion", fill = "Parity") +
  theme_minimal()
ggsave("notebooks/graph_sexe_parite.png", p11, width = 7, height = 5)

cat("DONE - All 11 graphs updated with English labels\n")
