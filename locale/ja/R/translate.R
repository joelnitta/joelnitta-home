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

# Start on `main`
git_branch_checkout("main")

# Make sure git status is clean
assertthat::assert_that(
  nrow(git_status()) == 0,
  msg = "git status not clean"
)

# Make backup of old `ja-source` branch (equivalent of `main`, but in JA)
# - first delete any existing backup
# if (git_branch_exists("ja-source-bak")) {
#   git_branch_delete("ja-source-bak")
# }
# git_branch_checkout("ja-source")
# git_branch_create("ja-source-bak")

# Switch back to main
git_branch_checkout("main")

# Create / update PO files
md2po(md_in = "_quarto.yml", po = "po/ja/_quarto.po")
md2po(md_in = "index.qmd", po = "po/ja/index.po")
md2po(md_in = "software.qmd", po = "po/ja/software.po")
md2po(md_in = "blog.qmd", po = "po/ja/blog.po")
md2po(md_in = "publications.qmd", po = "po/ja/publications.po")
md2po(md_in = "posts/2022-10-07_canaper/index.qmd",
  po = "po/ja/2022-10-07_canaper.po")

# (edit PO files)

# Cut off a new, temporary branch from `main`
# if (git_branch_exists("ja-source-temp")) {
#   git_branch_delete("ja-source-temp")
# }
# git_branch_create("ja-source-temp")

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

# Overwrite ja-source with new changes
git_branch_checkout("main")
git_branch_move("ja-source-temp", "ja-source", force = TRUE)

# Push to the remote
git_branch_checkout("ja-source")
git_push("origin", force = TRUE)

# All done, switch back to main
git_branch_checkout("main")
