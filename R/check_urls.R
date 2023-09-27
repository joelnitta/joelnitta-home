source("R/functions.R")

library(tidyverse)

mybib_meta <- read_csv("_bib/ref_metadata.csv") %>% select(-title)

# github
check_urls(mybib_meta$github)
# biorxv
check_urls(mybib_meta$biorxiv)
# figshare
check_urls(mybib_meta$figshare)
# dryad
check_urls(mybib_meta$dryad)

# TODO: automatic check for all URLs in source code
