# download country names --------------------------------------------------

url <- "http://atlas.media.mit.edu/static/db/raw/country_names.tsv.bz2"
bz2 <- paste0(country_dir, "country-names.tsv.bz2")

if (!file.exists(bz2)) {
  download.file(url, bz2, method = "wget")
}

if (!file.exists(paste0(country_dir, "country-names.tsv"))) {
  system(paste0("7z e ", bz2, " -oc:", country_dir))
}

# process for R package ---------------------------------------------------

## Obtain from DB
countries_db <- as_tibble(fread(paste0(country_dir, "country-names.tsv"), sep = "\t")) %>%
  rename(country = name, country_code = id_3char) %>%
  select(country, country_code)

## Obtain from API
countries_api <- fromJSON("http://atlas.media.mit.edu/attr/country/")

countries_api <- as_tibble(countries_api[[1]]) %>%
  select(name, display_id, id) %>%
  mutate(display_length = nchar(id)) %>%
  filter(display_length == 5) %>%
  rename(country = name, country_code = display_id) %>%
  select(country, country_code) %>%
  filter(!is.na(country_code))

## Check both sources match

countries_api %>%
  anti_join(countries_db)

countries_db %>%
  anti_join(countries_api)

## Add "The World"

country_names <- countries_api %>%
  rbind(c("the World", "all")) %>%
  mutate(country = iconv(country, from = "", to = "ASCII", sub = "byte")) %>%
  arrange(country)

save(
  country_names,
  file = paste0(country_dir, "country-names.RData"),
  compress = "xz"
)
