library(tidyverse)
library(janitor)
deprivation_raw <- read_csv("data/raw/imd2019lsoa.csv") |>
  clean_names()
glimpse(deprivation_raw)
deprivation <- deprivation_raw |>
  filter(indices_of_deprivation == "h. Living Environment Deprivation Domain" &
           measurement == "Score") |>
  select(lsoa_code = feature_code, value)

save(deprivation, file = "data/derived/deprivation.RData")
