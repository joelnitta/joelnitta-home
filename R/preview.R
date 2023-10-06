library(babelquarto)
library(servr)

# Optionally check URLs in references
#TODO: expand this to all URLs in website
check_urls <- FALSE
if (check_urls) {
  source("R/check_urls.R")
}

# Rendering to view locally (preview)
render_website()

# View locally
httw("_site")
