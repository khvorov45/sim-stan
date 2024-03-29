# Simulation summary
# Arseniy Khvorov
# Created 2019/11/07
# Last edit 2019/11/07

library(tools)
library(tidyverse)

sim_folder <- "sim"
sim_sum_folder <- "sim-summary"

read_one <- function(filepath) {
  read_csv(filepath, col_types = cols())
}

all_res <- list_files_with_exts(sim_folder, "csv") %>% map_dfr(read_one)

summ <- all_res %>%
  group_by(data, model, term, iter, true_val) %>%
  summarise(
    mean_mean = mean(mean),
    mean_sd = sd(mean),
    sd_mean = mean(sd),
    coverage = sum(true_val > `2.5%` & true_val < `97.5%`) / n(),
    nsim = n()
  )
write_csv(summ, file.path(sim_sum_folder, "summary.csv"))

