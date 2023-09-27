renv::use(
  "renv@1.0.3",
  "tidyverse@2.0.0",
  "viridisLite@0.4.2"
)

library(phytools)
library(ggtree)
library(tidyverse)
library(scico)
library(viridisLite)


## Load anole tree
anole.tree <- read.tree("http://www.phytools.org/eqg2015/data/anole.tre")

## Load anole trait data, extract snout-vent-length (svl) as named vector
svl <- read_csv("http://www.phytools.org/eqg2015/data/svl.csv") %>%
  mutate(svl = set_names(svl, species)) %>%
  pull(svl)

# Plot with default color scheme
contmap_obj <- contMap(anole.tree, svl, plot = FALSE)

plot(
  contmap_obj, 
  type="fan", 
  legend = 0.7*max(nodeHeights(anole.tree)),
  fsize = c(0.5, 0.7))
