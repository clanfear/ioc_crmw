library(tidyverse)
load("./data/analysis/london_data.RData")

glimpse(london_data)
london_data |> count(lsoa_code) |> arrange(desc(n))
london_data |> count(robbery) |> arrange(desc(n))
london_data |> count(burglary) |> arrange(desc(n))

ggplot(london_data, aes(x = burglary)) +
  geom_bar()
ggplot(london_data, aes(x = income_deprivation)) + 
  geom_histogram()

ggplot(london_data, aes(y = burglary, 
                        x = density)) +
  geom_point() +
  geom_smooth() +
  geom_smooth(method = "lm", color = "red")

london_data |> filter(density > 75000)
