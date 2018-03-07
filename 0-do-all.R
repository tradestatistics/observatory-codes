# Open oec-observatory-codes.Rproj before running this script

library(data.table)
library(jsonlite)
library(dplyr)

oec_scripts_dir <- "0-scripts/"
country_dir <- "1-country-data/"
product_dir <- "2-product-data/"

try(dir.create(country_dir))
try(dir.create(product_dir))

source(paste0(oec_scripts_dir, "1-country-names.R"))
source(paste0(oec_scripts_dir, "2-product-names.R"))
