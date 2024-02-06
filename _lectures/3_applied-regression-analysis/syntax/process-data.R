library(tidyverse)
library(janitor)
library(readxl)


# ACTIVITY

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

library(tidyverse)
list.files("data/raw")
deprivation_raw <- read_csv("data/raw/imd2019lsoa.csv")
glimpse(deprivation_raw)
deprivation_raw |> count(`Indices of Deprivation`)
deprivation_raw |> pull(FeatureCode) |> n_distinct()
deprivation <- deprivation_raw |>
  clean_names() |>
  filter(measurement == "Score" &
           indices_of_deprivation == "b. Income Deprivation Domain") |>
  select(lsoa_code = feature_code, income_deprivation = value)
save(deprivation, file = "data/derived/deprivation.RData")


# OLD

# First challenge: Multiple files
metro_files    <- list.files("./_lectures/1_quantitative-data-management/data/", pattern = "metropolitan", recursive = TRUE, full.names = TRUE)
metro_2022_raw <- read_csv(metro_files)

glimpse(metro_2022_raw)

metro_2022_crime <- metro_2022_raw |>
  clean_names() |>
  filter(crime_type %in% c("Violence and sexual offences", "Robbery", "Burglary")) |>
  count(lsoa_code, crime_type) |>
  pivot_wider(names_from = crime_type, values_from = n) |>
  clean_names() |>
  mutate(across(-lsoa_code, ~ifelse(is.na(.), 0, .))) |>
  rename(lsoa = lsoa_code)

glimpse(metro_2022_crime)

#London has 4,835 LSOAs so we have some extras!

density_2019_raw <- read_excel("./_lectures/1_quantitative-data-management/data/land-area-population-density-lsoa11-msoa11.xlsx", sheet = 2)

glimpse(density_2019_raw)
density_2019 <- density_2019_raw |>
  clean_names() |> 
  select(lsoa = lsoa11_code, density = people_per_sq_km)

glimpse(density_2019)

deprivation_2019_raw <- read_csv("./_lectures/1_quantitative-data-management/data/imd2019lsoa.csv")

glimpse(deprivation_2019_raw)

deprivation_2019 <- deprivation_2019_raw |>
  clean_names() |>
  mutate(index = str_sub(indices_of_deprivation, 4, -1),
         index = str_remove_all(index, "( )?(of |Deprivation|Domain|Index|Affecting|Barriers to |( \\(|and|,).*$)")) |>
  filter(measurement == "Decile") |>
  select(lsoa = feature_code, index, value) |>
  pivot_wider(names_from = index, values_from = value) |>
  clean_names()

glimpse(deprivation_2019)