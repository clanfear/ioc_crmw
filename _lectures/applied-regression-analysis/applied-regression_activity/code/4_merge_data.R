library(tidyverse)
load("./data/derived/crime_data.RData")
load("./data/derived/deprivation.RData")
load("./data/derived/pop_density.RData")

analytical_data <- pop_density |>
  left_join(crime_data) |>
  left_join(deprivation) |>
  rename(deprivation = value)

save(analytical_data, file = "./data/analytical/analytical_data.RData")
