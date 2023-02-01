library(tidyverse)
library(janitor)

metro_2022_raw <- read_csv(list.files("./_lectures/2_quantitative-data-management/data/", recursive = TRUE, full.names = TRUE))

glimpse(metro_2022_raw)

metro_2021_crime <- metro_2022_raw |>
  clean_names()

glimpse(metro_2021_crime)

deptivation_2019_raw <- read_csv("./_lectures/2_quantitative-data-management/data/imd2019lsoa.csv")


  mutate(borough = str_remove(lsoa_name, " [0-9].*$")) %>% 
  group_by(borough) %>%
  mutate(n = n()) %>%
  ungroup() %>%
  filter(n > 1000) %>%
  filter(crime_type %in% c("Burglary", "Robbery", "Violence and sexual offences", "Anti-social behaviour")) %>%
  mutate(crime_type = str_to_lower(str_replace_all(str_remove(crime_type, "-"), " ", "_"))) %>%
  count(borough, crime_type, month) %>%
  mutate(month = lubridate::ym(month)) %>%
  pivot_wider(names_from = crime_type, values_from = n) 


borough_deprivation <- vroom::vroom("https://clanfeat.github.io/ioc_iqa/_data/source_data/indices-of-multiple-deprivation-borough.csv") %>%
  select(borough = Area, 
         avg_deprivation = `Average Score - 2007`) %>%
  filter(borough %in% london_subregion$borough) %>%
  mutate(dep = ntile(avg_deprivation, 3)) %>%
  mutate(deprivation = case_when(
    dep ==1 ~ "Low",
    dep == 2 ~ "Medium",
    dep == 3 ~ "High",
    TRUE ~ "ERROR"
  )) %>%
  select(borough, deprivation, dep_score = avg_deprivation)

write_csv(borough_deprivation, file = "./_data/borough_deprivation.csv")

borough_pop_density <- vroom::vroom("./_data/source_data/housing-density-borough.csv") %>%
  filter(Year == 2021) %>%
  select(borough = Name, pop = Population, area = Square_Kilometres) %>%
  filter(borough %in% london_subregion$borough) |>
  janitor::clean_names(case = "title")

write_csv(borough_pop_density, file = "./_data/borough_pop_density.csv")

borough_pop_density <- borough_pop_density |> janitor::clean_names()

