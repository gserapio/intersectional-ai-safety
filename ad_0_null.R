# Fit a null model using all data
#
# Required Files:
# * 'df_v1v2v3.rds'
#
# Author: Greg Serapio-García

# load dependencies
library(brms)
library(performance)

# read in preprocessed data
df_v1v2v3 <- readRDS("df_v1v2v3.rds")

# set formula for null model
# intercept allows us to estimate the expected outcome value when all other
#   variables are set to 0
formula <- 
  "Q_Overall ~ 1 + (1 | rater_id) + (1 | item_id)"

# set priors for the thresholds using these cumulative proportions
prior_thresholds <- c(
  prior(normal(.440, 0.5), class = Intercept, coef = 1),
  prior(normal(.583, 0.5), class = Intercept, coef = 2) #,
  # commented out for null model:
  # prior(student_t(3, 0, 1), class = "b")
)

# fit and save model using brms
bfit_ad_0_effects <-
  brm(data = df_v1v2v3,
      family = cumulative("probit"),
      formula = formula,
      prior = prior_thresholds,
      iter = 4000, warmup = 1000, chains = 4, cores = 4,
      seed = 42,
      backend = "cmdstanr", threads = threading(2),
      file = "fits/bfit_ad_0_null")

# compute model performance metrics
perf_bfit_v1v2v3_probit_0_priors_updated <-
  model_performance(
    model = bfit_ad_0_null,
    metrics = c("LOOIC", "WAIC", "RMSE", "SIGMA", "LOGLOSS", "SCORE"))

# save model performance metrics
saveRDS(
  perf_ad_0_null,
  "performance_data/perf_ad_0_null.rds")
