# Run once to install everything the notebook needs
pkgs <- c("dplyr", "tidyr", "ggplot2", "lubridate", "readxl", "cluster",
          "randomForest", "e1071", "pROC", "plotly", "htmlwidgets",
          "gridExtra", "rmarkdown", "knitr")
to_install <- setdiff(pkgs, rownames(installed.packages()))
if (length(to_install)) install.packages(to_install, repos = "https://cloud.r-project.org")
cat("All packages ready.\n")
