library(readxl)
library(dplyr)
library(tidyr)
library(readr)
library(scales)

df <- read_excel("financialdata.xlsx")

df_selected <- df %>%
  select(
    symbol,
    shortName,
    industry,
    financialCurrency,
    returnOnEquity,
    profitMargins,
    revenueGrowth,
    currentRatio,
    operatingCashflow,
    earningsGrowth,
    priceToBook,
    forwardPE,
    pegRatio,
    forwardEps,
    marketCap
  )

df_selected <- df_selected %>%
  mutate(across(where(is.numeric), ~ replace_na(., 0)))

df_scaled <- df_selected %>%
  mutate(
    returnOnEquity_z      = scale(returnOnEquity),
    profitMargins_z       = scale(profitMargins),
    revenueGrowth_z       = scale(revenueGrowth),
    currentRatio_z        = scale(currentRatio),
    operatingCashflow_z   = scale(operatingCashflow),
    earningsGrowth_z      = scale(earningsGrowth)
  )

df_scored <- df_scaled %>%
  mutate(fin_health_score = round(
    0.25 * returnOnEquity_z +
      0.20 * profitMargins_z +
      0.15 * revenueGrowth_z +
      0.15 * currentRatio_z +
      0.15 * operatingCashflow_z +
      0.10 * earningsGrowth_z,
    2
  ))

write.csv(df_scored, "financial_health_index.csv", row.names = FALSE)

summary(df_scored$fin_health_score)

