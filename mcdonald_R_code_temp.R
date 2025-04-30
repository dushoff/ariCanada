library(readr)
library(dplyr)

base_url <- "https://raw.githubusercontent.com/dajmcdon/rvdss-canada/main/data/"
one_season <- "season_2024_2025/positive_tests.csv"
positive_tests <- read_csv(paste0(base_url, one_season))
years <- 2013:2024
all_seasons <- paste0("season_", years, "_", years + 1, "/positive_tests.csv")
all_seasons <- lapply(all_seasons, \(.x) read_csv(paste0(base_url, .x))) # ~ 30MB
positive_tests <- bind_rows(all_seasons)
positive_tests
