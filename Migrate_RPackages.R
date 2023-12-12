### Script name: Migrate_RPackages.R
### Purpose: Wrapper for package installation from one computer or R version to another 
### Author: Sajjad Toghiani
### Released Date: 14 Dec 2020
### Last Modified: 09 Dec 2023

# Run the comments below on your old computer or older R version
saved_dir <- "/Users/Sajjad.Toghiani/Downloads" # Replace with the correct directory on your old computer
packages <- installed.packages()[,"Package"]
save(packages, file = file.path(saved_dir, "Rpackages.RData"))

###--------------------------------------------------------------------------###

# Load the BiocManager package if not already loaded for your new R version
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}
library(BiocManager)

## Run the instant_pkgs object as a defined function on your new computer or newer R version
instant_pkgs <- function(pkgs) { 
  
  pkgs_miss <- pkgs[which(!pkgs %in% installed.packages()[, 1])]
  
  if (length(pkgs_miss) > 0) {
    # Check if packages are from Bioconductor or CRAN
    cran_packages <- pkgs_miss[!grepl("^Bioc", pkgs_miss)]
    bioc_packages <- pkgs_miss[grepl("^Bioc", pkgs_miss)]
    
    if (length(cran_packages) > 0) {
      install.packages(cran_packages)
    }
    
    if (length(bioc_packages) > 0) {
        BiocManager::install(bioc_packages)
    }
    
    if (length(cran_packages) > 0) {
      bioc_avail <- BiocManager::available()
      bioc_install <- setdiff(cran_packages,bioc_avail) 
      if (length(bioc_install) > 0) {
        BiocManager::install(bioc_install)
      } else {
        message("\n ...Some Bioconductor packages were not found in the repository!\n")
      }
    }
  }
  
 }

# Load and install packages from the older to newer R version
load(file = file.path(saved_dir, "Rpackages.RData"))
instant_pkgs(packages)

