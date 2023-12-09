# joelnitta-home

[![Netlify Status](https://api.netlify.com/api/v1/badges/4dec3009-d025-4fdf-b25e-76e98b2f34e1/deploy-status)](https://app.netlify.com/sites/laughing-cray-e2c0db/deploys)

Source code for [personal website of Joel Nitta](https://www.joelnitta.com).

Created with [Quarto](https://quarto.org/) in [R](https://www.r-project.org/). 

Site built by [GitHub actions](.github/workflows/build_site.yml) to the [`gh_pages` branch](https://github.com/joelnitta/joelnitta-home/tree/gh-pages), deployed by [Netlify](https://www.netlify.com/).

## Local deployment

- Generate the translated website with `babelquarto::render_website()`

- Preview the website with `servr::httw("_site")`

## Licenses

Code: [MIT](LICENSE)

Text and images, unless otherwise indicated: Creative Commons Attribution [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/legalcode)

Publications (PDF files): Indicated in each publication.