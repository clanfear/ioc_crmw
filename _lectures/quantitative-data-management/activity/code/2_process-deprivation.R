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
