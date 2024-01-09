library(tidyverse)
library(janitor)
library(readxl)

# First challenge: Multiple files

metro_2022_raw <- read_csv(list.files("./_lectures/2_quantitative-data-management/data/", pattern = "metropolitan", recursive = TRUE, full.names = TRUE))

glimpse(metro_2022_raw)

metro_2021_crime <- metro_2022_raw |>
  clean_names() |>
  filter(crime_type %in% c("Violence and sexual offences", "Robbery", "Burglary")) |>
  count(lsoa_code, crime_type) |>
  pivot_wider(names_from = crime_type, values_from = n) |>
  clean_names() |>
  mutate(across(-lsoa_code, ~ifelse(is.na(.), 0, .))) |>
  rename(lsoa = lsoa_code)

glimpse(metro_2021_crime)

#London has 4,835 LSOAs so we have some extras!

density_2019_raw <- read_excel("./_lectures/2_quantitative-data-management/data/land-area-population-density-lsoa11-msoa11.xlsx", sheet = 2)

glimpse(density_2019_raw)
density_2019 <- density_2019_raw |>
  clean_names() |> 
  select(lsoa = lsoa11_code, density = people_per_sq_km)

deprivation_2019_raw <- read_csv("./_lectures/2_quantitative-data-management/data/imd2019lsoa.csv")
glimpse(deprivation_2019_raw)

deprivation_2019 <- deprivation_2019_raw |>
  clean_names() |>
  mutate(index = str_sub(indices_of_deprivation, 4, -1),
         index = str_remove_all(index, "( )?(of |Deprivation|Domain|Index|Affecting|Barriers to |( \\(|and|,).*$)")) |>
  filter(measurement == "Decile") |>
  select(lsoa = feature_code, index, value) |>
  pivot_wider(names_from = index, values_from = value) |>
  clean_names()

# Why are some missing from crime data?

density_2019 |>
  left_join(metro_2021_crime) |>
  inner_join(deprivation_2019)

