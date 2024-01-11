
<!-- README.md is generated from README.Rmd. Please edit that file and render with rmarkdown::render("README.Rmd")-->

# joelnitta-home

[![Netlify
Status](https://api.netlify.com/api/v1/badges/4dec3009-d025-4fdf-b25e-76e98b2f34e1/deploy-status)](https://app.netlify.com/sites/laughing-cray-e2c0db/deploys)

Source code for [personal website of Joel
Nitta](https://www.joelnitta.com).

Created with [Quarto](https://quarto.org/) in
[R](https://www.r-project.org/).

Site built by [GitHub actions](.github/workflows/build_site.yml) to the
[`gh_pages`
branch](https://github.com/joelnitta/joelnitta-home/tree/gh-pages),
deployed by [Netlify](https://www.netlify.com/).

## Local deployment

- Generate the translated website with `babelquarto::render_website()`

- Preview the website with `servr::httw("_site")`

## Drafting a new blogpost

Use the [custom `draft_post()` function](R/functions.R):

``` r
post_qmd <- draft_post(
  slug = "example_post",
  title = "How to use the draft_post() function",
  desc = "Using templates to increase productivity",
  categories = c("R", "data")
)
#> ℹ Creating new directory at 'posts/2024-01-11_example_post'
#> ℹ Writing blog post template at 'posts/2024-01-11_example_post/index.qmd'
readr::read_lines(post_qmd)
#>  [1] "---"                                                                                                               
#>  [2] "title: \"How to use the draft_post() function\""                                                                   
#>  [3] "description:"                                                                                                      
#>  [4] "  Using templates to increase productivity"                                                                        
#>  [5] "date: 2024-01-11"                                                                                                  
#>  [6] "date-modified: today"                                                                                              
#>  [7] "image: featured.png"                                                                                               
#>  [8] "citation:"                                                                                                         
#>  [9] "  url: 2024-01-11_example_post"                                                                                    
#> [10] "lang: en"                                                                                                          
#> [11] "categories:"                                                                                                       
#> [12] "  - R"                                                                                                             
#> [13] "  - data"                                                                                                          
#> [14] "---"                                                                                                               
#> [15] ""                                                                                                                  
#> [16] "```{r}"                                                                                                            
#> [17] "#| label: setup"                                                                                                   
#> [18] "#| include: false"                                                                                                 
#> [19] ""                                                                                                                  
#> [20] "renv::use(lockfile = \"renv.lock\")"                                                                               
#> [21] "```"                                                                                                               
#> [22] ""                                                                                                                  
#> [23] ""                                                                                                                  
#> [24] "## Reproducibility {.appendix}"                                                                                    
#> [25] ""                                                                                                                  
#> [26] "- [Source code](https://github.com/joelnitta/joelnitta-home/tree/main/posts/2024-01-11_example_post/index.qmd)"    
#> [27] "- [`renv` lockfile](https://github.com/joelnitta/joelnitta-home/tree/main/posts/2024-01-11_example_post/renv.lock)"
fs::dir_delete(fs::path_dir(post_qmd))
```

## Licenses

Code: [MIT](LICENSE)

Text and images, unless otherwise indicated: Creative Commons
Attribution [CC BY
4.0](https://creativecommons.org/licenses/by/4.0/legalcode)

Publications (PDF files): Indicated in each publication.
