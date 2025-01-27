library(tidyverse)
library(janitor)

# Only download and extract zipfile if crime data doesn't exist
if(!file.exists("data/raw/crime/2022-10/2022-10-metropolitan-street.csv")){
  download.file("https://clanfear.github.io/ioc_crmw/_data/dpu-crime-met-2022.zip", "./data/raw/dpu-crime-met-2022.zip")
  unzip("./data/raw/dpu-crime-met-2022.zip", exdir = "./data/raw/crime/")
}


file_names <- list.files("data/raw/crime/", 
                         recursive = TRUE, 
                         full.names = TRUE)

metro_2022_raw <- read_csv(file_names)

metro_2022 <- metro_2022_raw |> 
  clean_names() |> 
  filter(crime_type %in% c("Robbery", "Burglary")) |>
  count(lsoa_code, crime_type) |>
  pivot_wider(names_from = crime_type,
              values_from = n) |>
  clean_names() |>
  # Replace NA values with zero; we'll have to do this again later once we get
  # all LSOA codes
  mutate(across(-lsoa_code, ~ifelse(is.na(.), 0, .)))

glimpse(metro_2022)

save(metro_2022, file = "data/derived/metro_2022.RData")

