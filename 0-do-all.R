# Open oec-observatory-codes.Rproj before running this script

library(data.table)
library(jsonlite)
library(dplyr)

oec_scripts_dir <- "0-scripts/"

country_dir <- "01-1-country-data-raw/"
country_dir_tidy <- "01-2-country-data-tidy/"

product_dir <- "02-1-product-data-raw/"
product_dir_tidy <- "02-2-product-data-tidy/"

try(dir.create(country_dir))
try(dir.create(country_dir_tidy))

try(dir.create(product_dir))
try(dir.create(product_dir_tidy))

source(paste0(oec_scripts_dir, "1-country-names.R"))
source(paste0(oec_scripts_dir, "2-product-names.R"))
