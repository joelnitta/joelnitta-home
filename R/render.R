library(babelquarto)

# First check URLs
check_urls <- TRUE
if (check_urls) {
  source("R/check_urls.R")
}

# Render
render_website(site_url = "https://www.joelnitta.com")
