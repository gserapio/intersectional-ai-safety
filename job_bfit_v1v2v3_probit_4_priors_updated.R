library(brms)
library(performance)

df_v1v2v3 <- readRDS("df_v1v2v3.rds")

# intermediate model
formula <- 
  "Q_Overall ~ race_detailed + DEMO_gender + DEMO_age + DEMO_education + Phase +  (1 | rater_id) + (1 | item_id)"

# set priors for the thresholds using these cumulative proportions
prior_thresholds <- c(
  prior(normal(.440, 0.5), class = Intercept, coef = 1),
  prior(normal(.583, 0.5), class = Intercept, coef = 2),
  prior(student_t(3, 0, 1), class = "b")
)


bfit_v1v2v3_probit_4_priors_updated <-
  brm(data = df_v1v2v3,
      family = cumulative("probit"),
      formula = formula,
      prior = prior_thresholds,
      iter = 4000, warmup = 1000, chains = 4, cores = 4,
      seed = 42,
      backend = "cmdstanr", threads = threading(2),
      file = "fits/bfit_v1v2v3_probit_4_priors_updated")

perf_bfit_v1v2v3_probit_4_priors_updated <-
  model_performance(
    model = bfit_v1v2v3_probit_4_priors_updated,
    metrics = c("LOOIC", "WAIC", "RMSE", "SIGMA", "LOGLOSS", "SCORE"))

saveRDS(
  perf_bfit_v1v2v3_probit_4_priors_updated,
  "performance_data/perf_bfit_v1v2v3_probit_4_priors_updated.rds")
