library(tidyverse)
library(janitor)

# Download file only if it doesn't exist yet
if(!file.exists("./data/raw/imd2019lsoa.csv")){
  download.file("https://clanfear.github.io/ioc_crmw/_data/imd2019lsoa.csv", "./data/raw/imd2019lsoa.csv")
}


deprivation_2019_raw <- read_csv("./data/raw/imd2019lsoa.csv")

glimpse(deprivation_2019_raw)

deprivation_2019 <- deprivation_2019_raw |>
  clean_names() |>
  filter(measurement == "Score" &
     indices_of_deprivation == "b. Income Deprivation Domain") |>
  select(lsoa_code = feature_code, income_deprivation = value)

save(deprivation_2019, file = "data/derived/deprivation_2019.RData")
