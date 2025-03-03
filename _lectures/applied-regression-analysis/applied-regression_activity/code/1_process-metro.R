library(tidyverse)
library(janitor)

file_list <- list.files("data/raw/dpu-crime-met-2022/", full.names = TRUE, recursive = TRUE)

crime_data_raw <- read_csv(file_list) |> 
  clean_names() 

crime_data <- crime_data_raw |> 
  filter(crime_type %in% c("Possession of weapons", 
                           "Violence and sexual offences", 
                           "Criminal damage and arson")) |>
  count(lsoa_code, crime_type, name = "crime_count") |>
  complete(lsoa_code = unique(crime_data_raw$lsoa_code), 
           crime_type,
          fill = list(crime_count = 0)) |>
  mutate(crime_type = case_match(crime_type,
    "Criminal damage and arson"    ~ "arson",
    "Possession of weapons"        ~ "weapon",
    "Violence and sexual offences" ~ "violence",
    .default                       = "ERROR"
  )) |>
  pivot_wider(names_from = crime_type, values_from = crime_count)

glimpse(crime_data)
save(crime_data, file = "data/derived/crime_data.RData")
