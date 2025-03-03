library(tidyverse)
library(readxl)
library(janitor)
density_raw <- read_excel("data/raw/land-area-population-density-lsoa11-msoa11.xlsx", sheet = "LSOA11")
glimpse(density_raw)

pop_density <- density_raw |> 
  clean_names() |>
  select(lsoa_code = lsoa11_code, density = people_per_sq_km)
save(pop_density, file = "./data/derived/pop_density.RData")
