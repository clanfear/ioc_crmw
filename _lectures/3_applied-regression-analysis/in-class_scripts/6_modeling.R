library(tidyverse)
load("./data/analysis/london_data.RData")

lm_burg <- lm(burglary ~ scale(income_deprivation) + density,
              data = london_data)
summary(lm_burg)

pois_burg <- glm(burglary ~ scale(income_deprivation) + density,
    data = london_data, family = poisson)
summary(pois_burg)
plot(pois_burg)
exp(0.064)
nb_burg<- MASS::glm.nb(burglary ~ scale(income_deprivation) + density,
             data = london_data)
summary(nb_burg)
anova(pois_burg, nb_burg)
lm_burg_quad <- lm(burglary ~ scale(income_deprivation) + density + I(density^2),
              data = london_data)
summary(lm_burg_quad)
lm_burg_cubic <- lm(burglary ~ scale(income_deprivation) + density + 
                     I(density^2) + I(density^3),
                   data = london_data)
summary(lm_burg_quad)
anova(lm_burg, lm_burg_quad, lm_burg_cubic)

library(car)
avPlot(lm_burg, "scale(income_deprivation)")
plot(lm_burg)
