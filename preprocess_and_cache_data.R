# Title: Preprocess and Cache Data
#
# This script reads in and pre-processes the DICES Dataset 
# (https://github.com/google-research-datasets/dices-dataset). Data is cached as
# 'df_v1v2v3.rds' (full data) and 'df_v1v2v3_harm' (expert-annotated data).
# Script can either be sourced or run interactively to view dataset diagnostics
# and visualizations.
#
# Required Files:
#
# Author: Greg Serapio-García


# Load Dependencies & Data ------------------------------------------------

# load dependencies (`pacman` automatically installs deps where necessary)
require("pacman")
pacman::p_load("tidyverse", "easystats", "skimr", "ggmosaic", "brms")

# load data
df_raw_all <-
  readr::read_csv("V1_2_3_diversity_study_normalized_raters_excluded.csv")


# Perform Cleanup ---------------------------------------------------------

# clean and recode rater demographic variables 
df_v1v2v3 <- df_raw_all %>%
  
  # convert rater_id and item_id to factors
  mutate(rater_id = factor(rater_id)) %>%
  mutate(item_id = factor(item_id)) %>%
  
  # convert race to factor
  mutate(DEMO_race = factor(DEMO_race)) %>%
  
  # make white people the reference group
  mutate(DEMO_race = relevel(DEMO_race, "White")) %>%
  
  # for education, convert no_answer to NAs
  # mutate(DEMO_education = na_if(DEMO_education, "Other")) %>%
  
  # convert education to ordinal
  # mutate(
  #   DEMO_education = factor(
  #     DEMO_education,
  #     ordered = T,
  #     labels = c("High school or below", "College degree or higher"))) %>%
  
  # convert education to factor to consider education NAs
  mutate(DEMO_education = factor(DEMO_education)) %>%
  
  # convert age to ordinal
  mutate(
    DEMO_age = factor(
      DEMO_age,
      ordered = T,
      labels = c("gen z", "millenial", "gen x+"))) %>%
  
  # convert question variables to ordinal
  mutate(across(c(Q_Overall, Q2_harmful_content,
                  Q3_unfair_bias, Q4_misinformation),
                as.ordered)) %>%
  
  # rename degree of harm variable
  rename(degree_of_harm = `Degree of harm`) %>%
  
  # convert degree of harm to ordinal
  mutate(
    degree_of_harm = factor(
      degree_of_harm,
      ordered = T,
      labels = c("Benign", "Debatable", "Moderate", "Extreme"))) %>%
  
  # convert phase, locale, gender to factor
  mutate(Phase = factor(Phase)) %>%
  mutate(DEMO_locale = factor(DEMO_locale)) %>%
  mutate(DEMO_gender = factor(DEMO_gender)) %>%
  
  
  # recode racial_ethnic
  mutate(
    race_detailed = case_when(
      racial_ethnic %in% c("White") ~ "White",
      racial_ethnic %in% c(
        "Asian", "East or South-East Asian") ~ "Asian",
      racial_ethnic %in% c("Black or African American") ~ "Black",
      racial_ethnic %in% c(
        "Indian",
        "Indian subcontinent (including Bangladesh, Bhutan, India, Maldives, Nepal, Pakistan, and Sri Lanka)"
        ) ~ "Indian Subcontinent",
      racial_ethnic %in% c(
        "American Indian or Alaska Native",
        "LatinX, Latino, Hispanic or Spanish Origin, American Indian or Alaska Native",
        "LatinX, Latino, Hispanic or Spanish Origin, Mexican Indigenous",
        "Native Hawaiian or other Pacific Islander",
        "White, American Indian or Alaska Native"
        ) ~ "Indigenous",
      racial_ethnic %in% c(
        "Latino, Hispanic or Spanish Origin",
        "LatinX, Latino, Hispanic or Spanish Origin") ~ "Latin(x)e",
      racial_ethnic %in% c(
        "Black or African American, East or South-East Asian",
        "LatinX, Latino, Hispanic or Spanish Origin, East or South-East Asian",
        "White, East or South-East Asian",
        "White, LatinX, Latino, Hispanic or Spanish Origin",
        "Mixed") ~ "Multiracial",
      racial_ethnic %in% c(
        "Middle Eastern or North African",
        "Other",
        "Prefer not to answer") ~ "Other"
      )
    ) %>%
  # make white raters the reference group
  mutate(race_detailed = relevel(factor(race_detailed), "White"))


# Inspect Raw and Recoded Demographics ------------------------------------

# inspect race/ethnicity distribution of DEMO_education == "Other"
# (BEFORE cleaning)
df_raw_all %>% 
  filter(DEMO_education == "Other") %>% 
  select(rater_id, racial_ethnic) %>% unique() %>%
  select(racial_ethnic) %>% table()

# view recoded racial distribution
# (AFTER cleaning)
df_v1v2v3 %>% 
  select(rater_id, race_detailed) %>% unique() %>% 
  select(race_detailed) %>% table


# Save to Disk ------------------------------------------------------------

# save preprocessed version of data
saveRDS(df_v1v2v3, "df_v1v2v3.rds")

# create df for expert-annotated harm
df_v1v2v3_harm <-
  df_v1v2v3 %>%
  filter(!is.na(degree_of_harm))

# view racial distribution of df_v1v2v3_harm
# it's the same because only the number of conversations per rater has changed
df_v1v2v3_harm %>% 
  select(rater_id, race_detailed) %>% unique() %>% 
  select(race_detailed) %>% table

saveRDS(df_v1v2v3_harm, "df_v1v2v3_harm.rds")
