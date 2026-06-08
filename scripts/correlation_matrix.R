library(tidyverse)
library(corrplot)

donnees <- read_tsv("data/etude_mere_enfant.csv", na = c("", "NA", "f"), show_col_types = FALSE)
donnees <- donnees %>%
  mutate(`CMV cord` = as.numeric(`CMV cord`),
         Howmanylivingchildrendoyouhave = as.numeric(Howmanylivingchildrendoyouhave))

# All continuous markers
markers <- c(
  "CMV mother", "RSV mother", "Enterovirus mother", "TT mother",
  "ratio CMV", "ratio RSV", "ratio ENTERO", "ratio TT",
  "CMV cord", "RSV cord", "Enterovirus cord", "TT Cord",
  "sCD14 [ng/ml]", "IFABP [pg/ml]", "cord sCD14 [ng/ml]",
  "Gestestational age of delivery",
  "Systolic blood pressure", "Diastolic blood pressure",
  "Birth weigh (tg)", "Birth length (cm)", "Head circumference (cm)",
  "Apgar score at 1st minute", "Apgar score in 5mins"
)

display_names <- c(
  "CMV mother", "RSV mother", "Enterovirus mother", "TT mother",
  "CMV ratio", "RSV ratio", "Enterovirus ratio", "TT ratio",
  "CMV cord", "RSV cord", "Enterovirus cord", "TT cord",
  "sCD14 (mother)", "IFABP (mother)", "sCD14 (cord)",
  "Gestational age", "Systolic BP", "Diastolic BP",
  "Birth weight", "Birth length", "Head circumference",
  "Apgar 1min", "Apgar 5min"
)
names(display_names) <- markers

groups <- list(
  list(hiv = "Negative", sex = "F", label = "HIV- / Female"),
  list(hiv = "Negative", sex = "M", label = "HIV- / Male"),
  list(hiv = "Positive", sex = "F", label = "HIV+ / Female"),
  list(hiv = "Positive", sex = "M", label = "HIV+ / Male")
)

col_pal <- colorRampPalette(c("#2166AC", "white", "#B2182B"))(200)

# Also generate individual plots
for (grp in groups) {
  sub <- donnees %>% 
    filter(`HIV STATUS` == grp$hiv, `child SEX` == grp$sex)
  
  cor_mat <- cor(sub[, markers], use = "pairwise.complete.obs")
  colnames(cor_mat) <- display_names[colnames(cor_mat)]
  rownames(cor_mat) <- display_names[rownames(cor_mat)]
  
  fname <- paste0("notebooks/cor_", grp$hiv, "_", grp$sex, ".png")
  png(fname, width = 1400, height = 1300, res = 120)
  corrplot(cor_mat, method = "color", type = "upper",
           col = col_pal, tl.col = "black", tl.cex = 0.55,
           number.cex = 0.45, addCoef.col = "black",
           cl.lim = c(-1, 1), is.corr = TRUE,
           title = grp$label, mar = c(0, 0, 3, 0),
           na.label = "NA", na.label.col = "gray")
  dev.off()
  cat(sprintf("Saved: %s (n=%d)\n", fname, nrow(sub)))
}

# Also create a combined 2x2 layout
png("notebooks/correlation_matrix.png", width = 2400, height = 2200, res = 130)
par(mfrow = c(2, 2), mar = c(1, 1, 3, 1))

for (grp in groups) {
  sub <- donnees %>% 
    filter(`HIV STATUS` == grp$hiv, `child SEX` == grp$sex)
  
  cor_mat <- cor(sub[, markers], use = "pairwise.complete.obs")
  colnames(cor_mat) <- display_names[colnames(cor_mat)]
  rownames(cor_mat) <- display_names[rownames(cor_mat)]
  
  corrplot(cor_mat, method = "color", type = "upper",
           col = col_pal, tl.col = "black", tl.cex = 0.45,
           number.cex = 0.3, addCoef.col = "black",
           cl.lim = c(-1, 1), is.corr = TRUE,
           title = grp$label, mar = c(0, 0, 2, 0),
           na.label = "NA", na.label.col = "gray")
}
dev.off()
cat(sprintf("Saved combined: notebooks/correlation_matrix.png\n"))