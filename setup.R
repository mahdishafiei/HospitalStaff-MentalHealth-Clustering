# Setup script for Mental Health Clustering Analysis
# This script installs required R packages

# List of required packages
required_packages <- c(
  "tidyverse",
  "cluster", 
  "factoextra",
  "ggplot2",
  "readr"
)

# Function to install packages if not already installed
install_if_missing <- function(packages) {
  for (pkg in packages) {
    if (!require(pkg, character.only = TRUE)) {
      cat("Installing", pkg, "...\n")
      install.packages(pkg, dependencies = TRUE)
      library(pkg, character.only = TRUE)
    } else {
      cat(pkg, "is already installed.\n")
    }
  }
}

# Install packages
cat("Setting up R environment for Mental Health Clustering Analysis...\n")
install_if_missing(required_packages)

cat("\nSetup complete! You can now run the analysis with:\n")
cat("Rscript analysis/clustering.R\n")
