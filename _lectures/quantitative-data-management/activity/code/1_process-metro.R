library(tidyverse)
library(janitor)
file_names <- list.files("data/raw/crime/", 
                         recursive = TRUE, 
                         full.names = TRUE)
file_names
metro_2022_raw <- read_csv(file_names)
metro_2022 <- metro_2022_raw |> 
  clean_names() |> 
  filter(crime_type %in% c("Robbery", "Burglary")) |>
  count(lsoa_code, crime_type) |>
  pivot_wider(names_from = crime_type,
              values_from = n) |>
  clean_names()
metro_2022
save(metro_2022, file = "data/derived/metro_2022.RData")
