# analysis/clustering.R
# Reproduce core steps: elbow method, K-means (k=3), and basic summaries/plots.

suppressPackageStartupMessages({
  library(tidyverse)
  library(cluster)
  library(factoextra)
  library(ggplot2)
})

message("Loading data...")
data_path <- file.path("data", "ghq28_responses.csv")
if (!file.exists(data_path)) {
  warning("Expected data at data/ghq28_responses.csv not found. Creating a small synthetic example instead.")
  set.seed(42)
  n <- 200
  demo <- tibble(
    gender = sample(c("Male","Female"), n, replace=TRUE, prob=c(0.25,0.75)),
    marital_status = sample(c("Single","Married"), n, replace=TRUE, prob=c(0.4,0.6)),
    education_level = sample(c("High school","Diploma","Bachelor","Masters","PhD+"), n, replace=TRUE, prob=c(0.02,0.10,0.66,0.16,0.06)),
    smoking = sample(c("No","Yes"), n, replace=TRUE, prob=c(0.91,0.09)),
    direct_exposure = sample(c("No","Yes"), n, replace=TRUE, prob=c(0.27,0.73)),
    chronic_disease = sample(c("No","Yes"), n, replace=TRUE, prob=c(0.90,0.10)),
    job = sample(c("Physician","Nurse","Laboratory Expert","Midwife","Nurse Assistance","Other"), n, replace=TRUE, prob=c(0.11,0.41,0.03,0.09,0.04,0.32))
  )
  ghq <- replicate(28, sample(0:3, n, replace=TRUE)) %>% as_tibble(.name_repair = ~ paste0("ghq", 1:28))
  df <- bind_cols(demo, ghq)
} else {
  df <- readr::read_csv(data_path, show_col_types = FALSE)
}

# Compute GHQ-28 total and subscales
ghq_cols <- paste0("ghq", 1:28)
stopifnot(all(ghq_cols %in% names(df)))

# Calculate GHQ-28 subscales as per the paper
df <- df %>% mutate(
  ghq_total = rowSums(select(., all_of(ghq_cols)), na.rm = TRUE),
  ghq_somatic = rowSums(select(., paste0("ghq", 1:7)), na.rm = TRUE),    # Items 1-7
  ghq_anxiety = rowSums(select(., paste0("ghq", 8:14)), na.rm = TRUE),   # Items 8-14
  ghq_social = rowSums(select(., paste0("ghq", 15:21)), na.rm = TRUE),   # Items 15-21
  ghq_depression = rowSums(select(., paste0("ghq", 22:28)), na.rm = TRUE) # Items 22-28
)

# Save table of baseline characteristics
dir.create("results/tables", showWarnings = FALSE, recursive = TRUE)
baseline <- df %>%
  summarise(
    n = n(),
    female_pct = mean(gender == "Female", na.rm = TRUE) * 100,
    bachelor_pct = mean(education_level == "Bachelor", na.rm = TRUE) * 100,
    married_pct = mean(marital_status == "Married", na.rm = TRUE) * 100,
    smoking_no_pct = mean(smoking == "No", na.rm = TRUE) * 100,
    direct_exposure_yes_pct = mean(direct_exposure == "Yes", na.rm = TRUE) * 100,
    chronic_no_pct = mean(chronic_disease == "No", na.rm = TRUE) * 100,
    mean_total = mean(ghq_total, na.rm = TRUE)
  )
readr::write_csv(baseline, "results/tables/baseline_summary.csv")

# Prepare numeric matrix for clustering (GHQ items only, as in the study)
X <- df %>% select(all_of(ghq_cols)) %>% as.matrix()

# Elbow method
message("Computing elbow method...")
wss <- numeric(10)
for (k in 1:10) {
  set.seed(123)
  km <- kmeans(X, centers = k, nstart = 10)
  wss[k] <- km$tot.withinss
}
elbow <- tibble(k = 1:10, wss = wss)
p_elbow <- ggplot(elbow, aes(k, wss)) +
  geom_line() + geom_point() +
  labs(title = "Elbow Method", x = "Number of clusters", y = "Within-cluster sum of squares")
dir.create("results/figures", showWarnings = FALSE, recursive = TRUE)
ggsave("results/figures/elbow_method.png", p_elbow, width = 7, height = 5, dpi = 150)

# K-means with k=3 (as suggested by the elbow in the paper)
message("Running K-means (k=3)...")
set.seed(123)
km3 <- kmeans(X, centers = 3, nstart = 50)
df$cluster <- factor(km3$cluster, levels = c(1,2,3), labels = c("Cluster 1","Cluster 2","Cluster 3"))

# Summaries by cluster
cluster_summary <- df %>%
  group_by(cluster) %>%
  summarise(
    n = n(),
    mean_total = mean(ghq_total),
    mean_somatic = mean(ghq_somatic),
    mean_anxiety = mean(ghq_anxiety),
    mean_social = mean(ghq_social),
    mean_depression = mean(ghq_depression),
    female_pct = mean(gender == "Female") * 100,
    bachelor_pct = mean(education_level == "Bachelor") * 100,
    nurse_pct = mean(job == "Nurse") * 100,
    direct_exposure_yes_pct = mean(direct_exposure == "Yes") * 100,
    .groups = 'drop'
  )
readr::write_csv(cluster_summary, "results/tables/cluster_summary.csv")

# GHQ-28 subscale analysis by cluster
subscale_analysis <- df %>%
  select(cluster, ghq_somatic, ghq_anxiety, ghq_social, ghq_depression) %>%
  group_by(cluster) %>%
  summarise(
    across(c(ghq_somatic, ghq_anxiety, ghq_social, ghq_depression), 
           list(mean = mean, sd = sd), na.rm = TRUE),
    .groups = 'drop'
  )
readr::write_csv(subscale_analysis, "results/tables/ghq_subscales_by_cluster.csv")

# Plot mean GHQ total by cluster
p_cluster_mean <- df %>%
  group_by(cluster) %>%
  summarise(mean_total = mean(ghq_total)) %>%
  ggplot(aes(cluster, mean_total)) + 
  geom_col(fill = c("#2E9FDF", "#E7B800", "#00AFBB"), alpha = 0.8) +
  labs(title = "Mean GHQ-28 Total by Cluster", x = "Cluster", y = "Mean GHQ-28 Total Score") +
  theme_minimal()
ggsave("results/figures/mean_total_by_cluster.png", p_cluster_mean, width = 7, height = 5, dpi = 150)

# Plot GHQ-28 subscales by cluster
subscale_long <- df %>%
  select(cluster, ghq_somatic, ghq_anxiety, ghq_social, ghq_depression) %>%
  pivot_longer(cols = -cluster, names_to = "subscale", values_to = "score") %>%
  group_by(cluster, subscale) %>%
  summarise(mean_score = mean(score, na.rm = TRUE), .groups = 'drop') %>%
  mutate(subscale = case_when(
    subscale == "ghq_somatic" ~ "Somatic Symptoms",
    subscale == "ghq_anxiety" ~ "Anxiety/Insomnia", 
    subscale == "ghq_social" ~ "Social Dysfunction",
    subscale == "ghq_depression" ~ "Severe Depression"
  ))

p_subscales <- ggplot(subscale_long, aes(x = subscale, y = mean_score, fill = cluster)) +
  geom_col(position = "dodge", alpha = 0.8) +
  labs(title = "Mean GHQ-28 Subscale Scores by Cluster", 
       x = "GHQ-28 Subscale", y = "Mean Score") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_manual(values = c("#2E9FDF", "#E7B800", "#00AFBB"))
ggsave("results/figures/ghq_subscales_by_cluster.png", p_subscales, width = 10, height = 6, dpi = 150)

message("Done. See results/ for outputs.")
message("Generated files:")
message("- results/tables/baseline_summary.csv")
message("- results/tables/cluster_summary.csv") 
message("- results/tables/ghq_subscales_by_cluster.csv")
message("- results/figures/elbow_method.png")
message("- results/figures/mean_total_by_cluster.png")
message("- results/figures/ghq_subscales_by_cluster.png")