#' Check for missing PDFS
#'
#' @param mybib_meta Metadata for bibliography, including column `file-pdf` with
#' path to PDF file
#'
#' @return Nothing unless one of the PDF files is missing
#'
check_pdfs <- function(mybib_meta) {
  pdf_files <- mybib_meta |>
    filter(!is.na(`file-pdf`)) |>
    pull(`file-pdf`)
  pdf_check <- fs::file_exists(pdf_files)
  pdf_missing <- pdf_check[pdf_check == FALSE]
  assertthat::assert_that(
    isTRUE(length(pdf_missing) == 0),
    msg = glue::glue("The following pdf files are missing: {paste(names(pdf_missing), sep = ', ')}")
  )
}

# Helper function to create a locale/lang directory populated with
# files needed for translation
site_create_locale <- function(lang = "ja") {

  # Create locale/{lang} folder if it does not yet exist
  locale_lang <- glue::glue("locale/{lang}")
  if (!fs::dir_exists(locale_lang)) fs::dir_create(locale_lang)

  # Copy all files needed for building webpage with quarto to locale/{lang}
  file_tibble <-
    fs::dir_ls(type = "file", all = TRUE) %>%
      tibble::tibble(file = .) %>%
      dplyr::filter(
        stringr::str_detect(
          file,
          "\\.DS_Store|\\.Rhistory|\\.Renviron|renv\\.lock",
          negate = TRUE
        )
      ) %>%
      dplyr::mutate(new_loc = glue::glue("locale/{lang}/{file}"))

  dir_tibble <-
    fs::dir_ls(type = "directory") %>%
        tibble::tibble(dir = .) %>%
        dplyr::filter(
          stringr::str_detect(
            dir,
            "^_site|^po$|renv|locale",
            negate = TRUE
          )
        ) %>%
        dplyr::mutate(new_loc = glue::glue("locale/{lang}/{dir}"))

  if (nrow(file_tibble) > 0) {
    purrr::walk2(
      file_tibble$file,
      file_tibble$new_loc,
      ~fs::file_copy(.x, .y, overwrite = TRUE))
  }

  if (nrow(dir_tibble) > 0) {
    purrr::walk2(
      dir_tibble$dir,
      dir_tibble$new_loc,
      ~fs::dir_copy(.x, .y, overwrite = TRUE))
  }
}

#' Check the status of a URL
#'
#' From [wikipedia](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes),
#' the response codes are as follows:
#'
#' - 1xx informational response: the request was received, continuing process
#' - 2xx successful:  the request was successfully received, understood, and
#'   accepted
#' - 3xx redirection: further action needs to be taken in order to complete the
#'   request
#' - 4xx client error: the request contains bad syntax or cannot be fulfilled
#' - 5xx server error: the server failed to fulfil an apparently valid request
#'
#' @param x Input URL @param time_limit Maximum amount of time to wait (in
#' seconds) before giving up on URL
#'
#' @return The status code of the URL. If the URL did not work at all, "no
#' response" is returned.
#'
#' @examples
#' # Inspired by
#' https://stackoverflow.com/questions/52911812/check-if-url-exists-in-r
#' some_urls <- c( "http://content.thief/", "doh", NA,
#'   "http://rud.is/this/path/does/not_exist",
#'   "https://www.amazon.com/s/ref=nb_sb_noss_2?url=search-alias%3Daps&field-keywords=content+theft", # nolint
#'   "https://rud.is/b/2018/10/10/geojson-version-of-cbc-quebec-ridings-hex-cartograms-with-example-usage-in-r/") # nolint
#'   purrr::map_chr(some_urls, url_status)
#'
url_status <- function (x, time_limit = 60) {

  # Check that we have an internet connection
  assertthat::assert_that(
    pingr::is_online(),
    msg = "No internet connection detected")

  # safe version of httr::HEAD
  sHEAD <- purrr::safely(httr::HEAD)

  # safe version of httr::GET
  sGET <- purrr::safely(httr::GET)

  # Return NA if input is NA
  if (isTRUE(any(is.na(x)))) return (NA_character_)

  # Check URL using HEAD
  # see httr::HEAD()
  # "This method is often used for testing hypertext links for validity, 
  # accessibility, and recent modification"
  res <- sHEAD(x, httr::timeout(time_limit))

  # If that returned an error or a non-200 range status
  # (meaning the URL is broken)
  # try GET next
  if (is.null(res$result) || ((httr::status_code(res$result) %/% 200) != 1)) {

    res <- sGET(x, httr::timeout(time_limit))

    # If neither HEAD nor GET work, it's hard error
    if (is.null(res$result)) return("no response") # or whatever you want to return on "hard" errors # nolint

    return(as.character(httr::status_code(res$result)))

  } else {

    return(as.character(httr::status_code(res$result)))

  }

}

# Publications -----

# Define functions for formatting a citation

#' Make a link button
#'
#' @param key_select Bibtex key
#' @param link_type Type of link ("github", "biorxiv", "figshare", "dryad",
#' "pdf")
#' Should be one of column names in bibliography metadata
#' @param text Text to include next to to icon.
#' @param bib_df Bibliography data (`mybib_df`)
#'
#' @return HTML to make a link button
link_button <- function(key_select, link_type, text, bib_df = mybib_df) {
  url <- filter(bib_df, key == key_select)[[link_type]]
  if (is.na(url)) return(NULL)
  distilltools::icon_link(icon = link_type, text = text, url = url)
}

#' Make a DOI link
#'
#' @param key_select Bibtex key
#' @param bib_df Bibliography data as dataframe
#'
#' @return HTML with link to DOI corresponding to citation specified with key
doi_link <- function(key_select, bib_df = mybib_df) {
  doi <- filter(bib_df, key == key_select) %>% pull(doi)
  if (is.na(doi)) return(NULL)
  glue("DOI: [{doi}](https://doi.org/{doi})")
}

#' Print a simple reference
#'
#' @param key_select Bibtex key
#' @param bib Bibtex bibliography read in with RefManageR::ReadBib()
#'
#' @return Text of reference
print_ref_simple <- function(key_select, bib = mybib) {
  assertthat::assert_that(
    key_select %in% names(bib),
    msg = glue::glue("{key_select} not in bib")
  )
  # Silently cite the key
  NoCite(bib, key_select)
  # Capture the output of printing the reference
  capture.output(foo <- print(bib[[key_select]])) %>%
    paste(collapse = " ") %>%
    # Make my name in bold
    str_replace_all("Nitta, J. H.", "__Nitta, J. H.__") %>%
    str_replace_all("J. H. Nitta", "__J. H. Nitta__")
}

#' Print a reference with link buttons
#'
#' @param key_select Bibtex key
#' @param bib Bibtex bibliography read in with RefManageR::ReadBib()
#' @param bib_df Bibliography data as dataframe, including metadata
#' (links to github, biorxiv, dryad, etc)
#'
#' @return Text of reference, with HTML buttons to links below it
print_ref <- function(key_select, bib = mybib, bib_df = mybib_df) {
  ref <- print_ref_simple(key_select = key_select, bib = bib)
  doi <- doi_link(key_select, bib_df = bib_df)
  biorxiv <- link_button(key_select, "biorxiv", "Preprint", bib_df)
  github <- link_button(key_select, "github", "Code", bib_df)
  dryad <- link_button(key_select, "dryad", "Data", bib_df)
  figshare <- link_button(key_select, "figshare", "Data", bib_df)
  pdf <- link_button(key_select, "file-pdf", "PDF", bib_df)

  main_ref <- paste(ref, doi, sep = " ")
  buttons <- paste(biorxiv, github, dryad, figshare, pdf)
  paste(main_ref, buttons, sep = "<br>")
}

# Check that a vector of URLs is either NA or successful
#' @param urls Input URLs (may include NA values)
#' @return Logical vector; TRUE if URL returns a 200 or if the input is NA,
#' FALSE otherwise
check_urls <- function(urls) {
  check <- purrr::map_chr(urls, url_status)
  fail <- urls[which(check != "200")]
  na_s <- is.na(urls)
  success <- tidyr::replace_na(check == "200", FALSE)
  total_success <- na_s | success
  assertthat::assert_that(
    length(fail) == 0,
    msg = glue::glue("The following URLs are broken: {paste(fail, collapse = ', ')}")
)
}

# Blog ----

#' Draft a blog post
#'
#' Writes a .qmd file including a YAML header for a blog post
#'
#' @param slug Single string to use in the post URL. Should use snake case.
#' @param title Blog post title.
#' @param desc Short blog post description (one to two sentences).
#' @param categories Character vector of blog post categories (tags).
#' @param feat Name of file to use as featured image.
#' @param lang Language code.
#'
#' @return Path to the newly created blog post .qmd file
#' @examples
#' post_qmd <- draft_post(
#'   slug = "example_post"
#'   title = "How to use the draft_post() function",
#'   desc = "Using templates to increase productivity",
#'   categories = c("R", "data")
#' )
#' readr::read_lines(post_qmd)
#' fs::dir_delete(fs::path_dir(post_qmd))
#'
draft_post <- function(
  slug, title, desc, categories = NULL, feat = "featured.png", lang = "en") {
  today <- Sys.Date()
  date_slug <- paste0(today, "_", slug)
  post_dir <- fs::path("posts", date_slug)
  post_file <- fs::path(post_dir, "index.qmd")
  if (!fs::dir_exists(post_dir)) {
    cli::cli_alert_info("Creating new directory at {.file {post_dir}}")
    fs::dir_create(post_dir)
  }
  qmd_lines <- readr::read_lines("_templates/blog_post.qmd") |>
    stringr::str_replace_all(
      c(
        TITLE = title,
        DESCRIPTION = desc,
        DATE = as.character(today),
        IMAGE = feat,
        URL = date_slug,
        LANG = lang)
    )
  if (!is.null(categories)) {
    yaml_head_border <- which(grepl("^---$", qmd_lines))
    qmd_lines <- append(
      x = qmd_lines,
      values = c(
        "categories:",
        paste("  -", categories)
      ),
      after = yaml_head_border[2] - 1
    )
  }
  cli::cli_alert_info("Writing blog post template at {.file {post_file}}")
  readr::write_lines(qmd_lines, post_file)
  post_file
}
