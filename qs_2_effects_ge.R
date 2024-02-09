# Fit a group effects model using data with qualitative severity ratings only
#
# Required Files:
# * 'df_v1v2v3_harm.rds'
#
# Author: Greg Serapio-García

# load dependencies
library(brms)
library(performance)

# read in preprocessed data
df_v1v2v3_harm <- readRDS("df_v1v2v3_harm.rds")

# set model formula:
# allow the effect of convo severity to vary across raters
formula_harm <- 
  "Q_Overall ~ race_detailed + DEMO_gender + DEMO_age + degree_of_harm + DEMO_education + (degree_of_harm | rater_id) + (1 | item_id)"

# set priors for the thresholds using these cumulative proportions
harm_prior_thresholds <- c(
  prior(normal(.279, 0.5), class = Intercept, coef = 1),
  prior(normal(.440, 0.5), class = Intercept, coef = 2),
  prior(student_t(3, 0, 1), class = "b")
)

# fit and save model using brms
bfit <-
  # **NB** degree of harm is only found in a SUBSET of the data
  brm(data = df_v1v2v3_harm,
      family = cumulative("probit"),
      formula = formula_harm,
      prior = harm_prior_thresholds,
      iter = 4000, warmup = 1000, chains = 4, cores = 4,
      seed = 42,
      backend = "cmdstanr", threads = threading(2),
      file = "fits/bfit_qs_2_effects_ge")

# compute model performance metrics
perf <- 
  model_performance(
    model = bfit,
    metrics = c(
      "LOOIC", "WAIC", "R2", "R2_adj", "RMSE", "SIGMA", "LOGLOSS", "SCORE"))

# save model performance metrics
saveRDS(perf, "performance_data/perf_qs_2_effects_ge.rds")
