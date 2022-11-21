# R script to translate the website contents from English to Japanese
# using PO files.
# This should be run interactively

library(dovetail)
library(quarto)
library(gert)

source("R/functions.R")

# Create subdirectory populated with files to translate to JA
# (will over-write any existing translation)
site_create_locale("ja")

# Create / update PO files
md2po(md_in = "_quarto.yml", po = "po/ja/_quarto.po")
md2po(md_in = "index.qmd", po = "po/ja/index.po")
md2po(md_in = "software.qmd", po = "po/ja/software.po")
md2po(md_in = "blog.qmd", po = "po/ja/blog.po")
md2po(md_in = "publications.qmd", po = "po/ja/publications.po")
md2po(md_in = "posts/2022-10-07_canaper/index.qmd",
  po = "po/ja/2022-10-07_canaper.po")

# (edit PO files)

# Translate files
po2md(
  md_in = "_quarto.yml",
  po = "po/ja/_quarto.po",
  md_out = "locale/ja/_quarto.yml"
)
po2md(
  md_in = "index.qmd",
  po = "po/ja/index.po",
  md_out = "locale/ja/index.qmd"
)
po2md(
  md_in = "software.qmd",
  po = "po/ja/software.po",
  md_out = "locale/ja/software.qmd"
)
po2md(
  md_in = "blog.qmd",
  po = "po/ja/blog.po",
  md_out = "locale/ja/blog.qmd"
)
po2md(
  md_in = "publications.qmd",
  po = "po/ja/publications.po",
  md_out = "locale/ja/publications.qmd"
) # nolint
po2md(
  md_in = "posts/2022-10-07_canaper/index.qmd",
  po = "po/ja/2022-10-07_canaper.po",
  md_out = "locale/ja/posts/2022-10-07_canaper/index.qmd"
)

# Render any blog posts that have been translated
quarto_render("locale/ja/posts/2022-10-07_canaper/index.qmd")

# Render translated webpage for local viewing
# and make any manual tweaks needed to translated docs
quarto_preview("locale/ja")
quarto_preview_stop()

# After verifying that site looks good, commit changes
# (shouldn't need to add any new files;
# all changes are translations of existing files)
git_commit_all("Translate to JA")
