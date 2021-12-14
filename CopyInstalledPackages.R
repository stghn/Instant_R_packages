### Script name: CopyInstalledPackages.R
### Purpose: Wrapper for package installation and loading from one computer or R version to another 
### Author: Sajjad Toghiani
### Released Date: 14 Dec 2020
### Last Modified: 14 Dec 2020

## Run the comments below on your old computer or older R version
setwd("/Users/Downloads") # or set any other existing directory in your old computer in which you want to save your package lists
packages <- installed.packages()[,"Package"]
save(packages, file="Rpackages")

###--------------------------------------------------------------------------###

## Copy your saved file "Rpackages" to any existing directory in your new computer
setwd("/Users/Downloads")

## Run the instant_pkgs object as a defined function on your new computer or newer R version [source: https://gist.github.com/raffdoc/2956081]
instant_pkgs <- function(pkgs) { 
  pkgs_miss <- pkgs[which(!pkgs %in% installed.packages()[, 1])]
  if (length(pkgs_miss) > 0) {
    install.packages(pkgs_miss)
  }
  
  if (length(pkgs_miss) == 0) {
    message("\n ...Packages were already installed!\n")
  }
  
  ## install packages not already loaded:
  pkgs_miss <- pkgs[which(!pkgs %in% installed.packages()[, 1])]
  if (length(pkgs_miss) > 0) {
    install.packages(pkgs_miss)
  }
  
  ## load packages not already loaded:
  attached <- search()
  attached_pkgs <- attached[grepl("package", attached)]
  need_to_attach <- pkgs[which(!pkgs %in% gsub("package:", "", attached_pkgs))]
  
  if (length(need_to_attach) > 0) {
    for (i in 1:length(need_to_attach)) require(need_to_attach[i], character.only = TRUE)
  }
  
  if (length(need_to_attach) == 0) {
    message("\n ...Packages were already loaded!\n")
  }
}

# The following command line will install all the packages listed in "Rpackages" from the older to newer computer or R version:
instant_pkgs("Rpackages")
