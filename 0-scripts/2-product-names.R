# download product names (SITC rev 2, HS92/96/02/07) ----------------------

url <- "http://atlas.media.mit.edu/static/db/raw/products_sitc_rev2.tsv.bz2"
bz2 <- paste0(product_dir, "sitc-rev2-product-names.tsv.bz2")
tsv <- paste0(product_dir, "sitc-rev2-product-names.tsv")

if (!file.exists(bz2)) {
  download.file(url, bz2, method = "wget")
}

if (!file.exists(tsv)) {
  system(paste0("7z e ", bz2, " -oc:", product_dir))
}

url <- "http://atlas.media.mit.edu/static/db/raw/products_hs_92.tsv.bz2"
bz2 <- paste0(product_dir, "hs-rev1992-product-names.tsv.bz2")
tsv <- paste0(product_dir, "hs-rev1992-product-names.tsv")

if (!file.exists(bz2)) {
  download.file(url, bz2, method = "wget")
}

if (!file.exists(tsv)) {
  system(paste0("7z e ", bz2, " -oc:", product_dir))
}

url <- "http://atlas.media.mit.edu/static/db/raw/products_hs_96.tsv.bz2"
bz2 <- paste0(product_dir, "hs-rev1996-product-names.tsv.bz2")
tsv <- paste0(product_dir, "hs-rev1996-product-names.tsv")

if (!file.exists(bz2)) {
  download.file(url, bz2, method = "wget")
}

if (!file.exists(tsv)) {
  system(paste0("7z e ", bz2, " -oc:", product_dir))
}

url <- "http://atlas.media.mit.edu/static/db/raw/products_hs_02.tsv.bz2"
bz2 <- paste0(product_dir, "hs-rev2002-product-names.tsv.bz2")
tsv <- paste0(product_dir, "hs-rev2002-product-names.tsv")

if (!file.exists(bz2)) {
  download.file(url, bz2, method = "wget")
}

if (!file.exists(tsv)) {
  system(paste0("7z e ", bz2, " -oc:", product_dir))
}

url <- "http://atlas.media.mit.edu/static/db/raw/products_hs_07.tsv.bz2"
bz2 <- paste0(product_dir, "hs-rev2007-product-names.tsv.bz2")
tsv <- paste0(product_dir, "hs-rev2007-product-names.tsv")

if (!file.exists(bz2)) {
  download.file(url, bz2, method = "wget")
}

if (!file.exists(tsv)) {
  system(paste0("7z e ", bz2, " -oc:", product_dir))
}

# process for R package ---------------------------------------------------

## HS92

hs92 <- fromJSON("http://atlas.media.mit.edu/attr/hs92/")

hs92 <- as_tibble(hs92[[1]]) %>%
  select(name, id, color)

hs92_groups <- hs92 %>%
  select(name, id) %>%
  filter(nchar(id) == 2) %>%
  distinct() %>%
  rename(group_name = name, group_id = id)

hs92_product_names <- hs92 %>%
  filter(nchar(id) >= 6) %>%
  mutate(group_id = substr(id, 1, 2)) %>%
  mutate(id = substr(id, 3, nchar(id))) %>%
  rename(product_name = name, hs92 = id) %>%
  left_join(hs92_groups) %>%
  mutate(
    product_name = iconv(product_name, from = "", to = "ASCII", sub = "byte"),
    group_name = iconv(group_name, from = "", to = "ASCII", sub = "byte")
  ) %>%
  select(product_name, hs92, group_name, group_id, color)

save(
  hs92_product_names,
  file = paste0(product_dir, "hs-rev1992-product-names.RData"),
  compress = "xz"
)

## SITC

sitc <- fromJSON("http://atlas.media.mit.edu/attr/sitc/")

sitc <- as_tibble(sitc[[1]]) %>%
  select(name, id, color)

sitc_groups <- sitc %>%
  select(name, id) %>%
  filter(nchar(id) == 2) %>%
  distinct() %>%
  rename(group_name = name, group_id = id)

sitc_product_names <- sitc %>%
  filter(nchar(id) >= 6) %>%
  mutate(group_id = substr(id, 1, 2)) %>%
  mutate(id = substr(id, 3, nchar(id))) %>%
  rename(product_name = name, sitc = id) %>%
  left_join(sitc_groups) %>%
  mutate(
    product_name = iconv(product_name, from = "", to = "ASCII", sub = "byte"),
    group_name = iconv(group_name, from = "", to = "ASCII", sub = "byte")
  ) %>%
  select(product_name, sitc, group_name, group_id, color)

save(
  hs92_product_names,
  file = paste0(product_dir, "sitc-rev2-product-names.RData"),
  compress = "xz"
)
