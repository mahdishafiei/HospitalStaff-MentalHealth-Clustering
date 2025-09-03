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

# Compute GHQ-28 total
ghq_cols <- paste0("ghq", 1:28)
stopifnot(all(ghq_cols %in% names(df)))
df <- df %>% mutate(ghq_total = rowSums(select(., all_of(ghq_cols)), na.rm = TRUE))

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
    female_pct = mean(gender == "Female") * 100,
    bachelor_pct = mean(education_level == "Bachelor") * 100,
    nurse_pct = mean(job == "Nurse") * 100,
    direct_exposure_yes_pct = mean(direct_exposure == "Yes") * 100
  )
readr::write_csv(cluster_summary, "results/tables/cluster_summary.csv")

# Plot mean GHQ total by cluster (similar to Fig. 2 concept)
p_cluster_mean <- df %>%
  group_by(cluster) %>%
  summarise(mean_total = mean(ghq_total)) %>%
  ggplot(aes(cluster, mean_total)) + geom_col() +
  labs(title = "Mean GHQ-28 Total by Cluster", x = NULL, y = "Mean total")
ggsave("results/figures/mean_total_by_cluster.png", p_cluster_mean, width = 7, height = 5, dpi = 150)

message("Done. See results/ for outputs.")