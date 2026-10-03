# Customer Segmentation and Predictive Analytics in R
Lab Problem Statement 6 | UCI Online Retail dataset | K-Means, Hierarchical, PCA, Random Forest, SVM, Plotly 3D

## Folder structure
```
R_Customer_Segmentation/
├── Customer_Segmentation.Rmd      <- MAIN NOTEBOOK (knit this; contains problem statement, code, results, interpretation)
├── Customer_Segmentation.R        <- same code as a plain script (run with Rscript)
├── install_packages.R             <- installs required packages
├── data/
│   ├── generate_synthetic_data.R  <- test-only fallback (see below)
│   └── (put "Online Retail.xlsx" here)
└── outputs/
    ├── figures/                   <- PNGs saved automatically (elbow, dendrogram, PCA, ROC, ...)
    ├── tables/                    <- CSVs saved automatically (profiles, metrics, recommendations)
    └── customer_clusters_3d.html  <- interactive Plotly 3D plot (created on run)
```

## How to run
1. Install R (>= 4.1) and RStudio.
2. Open the project folder in RStudio, then run `source("install_packages.R")` once.
3. Get the data. Either:
   - do nothing; the notebook tries to download it from UCI automatically, or
   - download **Online Retail** from https://archive.ics.uci.edu/dataset/352/online+retail and put `Online Retail.xlsx` in `data/`.
4. Open `Customer_Segmentation.Rmd` and click **Knit** (HTML). The first run takes a few minutes: reading the xlsx, the distance matrix for ~4,300 customers, and SVM tuning. The data is cached to `data/online_retail.rds` for faster re-knits.

## Getting the PDF for submission
Open the knitted `Customer_Segmentation.html` in Chrome/Edge, then **Print → Save as PDF**.
(Optionally set `output: pdf_document` and install TinyTeX with `tinytex::install_tinytex()`, but Plotly 3D will then not render in the PDF; the standalone HTML in `outputs/` covers that deliverable.)

## Deliverable checklist (maps to the lab sheet)
| # | Deliverable | Where in the notebook |
|---|---|---|
| 1 | Preprocessing and feature engineering | Data Preprocessing / Feature Engineering |
| 2 | Elbow graph | K-Means > Elbow Method |
| 3 | K-Means segmentation | K-Means > Final model |
| 4 | Hierarchical clustering + dendrogram | Hierarchical Clustering |
| 5 | Silhouette + comparison | Silhouette Analysis, K-Means vs Hierarchical |
| 6 | PCA 2D visualisation | PCA Visualisation |
| 7 | Cluster profiling | Cluster Profiling |
| 8 | Random Forest + SVM | Supervised Learning |
| 9 | Accuracy / Precision / Recall / F1 / AUC / Confusion matrix | Model evaluation |
| 10 | Feature importance | Feature Importance |
| 11 | Interactive 3D Plotly | Interactive 3D Visualisation |
| 12 | Marketing recommendations | Marketing Recommendations |

## Notes
- `USE_SYNTHETIC=1` (an environment variable) makes the notebook use a generated stand-in dataset. It exists only for testing the code without internet. **Do not submit results from synthetic data.**
- After knitting on the real data, read the Cluster Profiling table and check the automatic segment names (Champions, Loyal, ...) before writing your final interpretation. The conclusion text fills in numbers automatically, but you should still review the wording.
- Remember to push the whole folder to your Git repository and add the link to your submission.
