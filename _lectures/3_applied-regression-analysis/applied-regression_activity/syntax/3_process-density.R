library(tidyverse)
library(janitor)
library(readxl)

# Download file only if it doesn't exist yet; use mode wb for binary file
if(!file.exists("./data/raw/land-area-population-density-lsoa11-msoa11.xlsx")){
  download.file("https://clanfear.github.io/ioc_crmw/_data/land-area-population-density-lsoa11-msoa11.xlsx", "./data/raw/land-area-population-density-lsoa11-msoa11.xlsx", mode = "wb")
}

density_2019_raw <- read_excel("./data/raw/land-area-population-density-lsoa11-msoa11.xlsx", sheet = 2)


glimpse(density_2019_raw)

density_2019 <- density_2019_raw |>
  clean_names() |> 
  select(lsoa_code = lsoa11_code, density = people_per_sq_km)

glimpse(density_2019)

save(density_2019, file = "./data/derived/density_2019.RData")
