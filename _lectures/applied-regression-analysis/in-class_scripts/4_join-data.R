library(tidyverse)

load("./data/derived/metro_2022.RData")
load("./data/derived/deprivation_2019.RData")
load("./data/derived/density_2019.RData")

# Note that density data are ONLY for London LSOAs and are complete. Thus we can
# start with it and only join what is relevant to it.

london_data <- density_2019 |>
  left_join(deprivation_2019) |>
  left_join(metro_2022) |>
  # Need to replace NAs with zeroes in crime data
  mutate(across(c(burglary, robbery), ~ replace_na(., 0)))
glimpse(london_data)         

save(london_data, file = "./data/analysis/london_data.RData")
