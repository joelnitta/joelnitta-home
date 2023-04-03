# R script to translate the website contents from English to Japanese
# using PO files.
# This should be run interactively

library(dovetail)
library(quarto)
library(gert)

# Create subdirectory for translation
if (!fs::dir_exists("_locale/ja/")) {
  fs::dir_create("_locale/ja")
}

# Recursively copy files needed to build translation to _locale/ja
system(glue::glue(
  "rsync -avu \\
  --exclude '_locale*' --exclude '.git*' --exclude '_site' \\
  --exclude 'renv' --exclude 'working' --exclude 'po' \\
  ./ ./_locale/ja/"))

# Create / update PO files
md2po(md_in = "_quarto.yml", po = "_po/ja/_quarto.po")
md2po(md_in = "index.qmd", po = "_po/ja/index.po")
md2po(md_in = "software.qmd", po = "_po/ja/software.po")
md2po(md_in = "blog.qmd", po = "_po/ja/blog.po")
md2po(md_in = "publications.qmd", po = "_po/ja/publications.po")
md2po(md_in = "talks.qmd", po = "_po/ja/talks.po")
md2po(md_in = "posts/2022-10-07_canaper/index.qmd",
  po = "_po/ja/2022-10-07_canaper.po")

# (edit PO files to use for translation)

# Translate source files
po2md(
  md_in = "_quarto.yml",
  po = "_po/ja/_quarto.po",
  md_out = "_locale/ja/_quarto.yml"
)
po2md(
  md_in = "index.qmd",
  po = "_po/ja/index.po",
  md_out = "_locale/ja/index.qmd"
)
po2md(
  md_in = "software.qmd",
  po = "_po/ja/software.po",
  md_out = "_locale/ja/software.qmd"
)
po2md(
  md_in = "blog.qmd",
  po = "_po/ja/blog.po",
  md_out = "_locale/ja/blog.qmd"
)
po2md(
  md_in = "publications.qmd",
  po = "_po/ja/publications.po",
  md_out = "_locale/ja/publications.qmd"
)
po2md(
  md_in = "talks.qmd",
  po = "_po/ja/talks.po",
  md_out = "_locale/ja/talks.qmd"
)
po2md(
  md_in = "posts/2022-10-07_canaper/index.qmd",
  po = "_po/ja/2022-10-07_canaper.po",
  md_out = "_locale/ja/posts/2022-10-07_canaper/index.qmd"
)

# Render any blog posts that have been newly translated
# (can skip those without new translations)
quarto_render("_locale/ja/posts/2022-10-07_canaper/index.qmd")

# Render translated webpage for local viewing
# and make any manual tweaks needed to translated docs
# - need to manually edit for spaces:
#    - software.qmd
#    - publications.qmd
quarto_preview("_locale/ja")
quarto_preview_stop()

# After verifying that site looks good, commit changes to ja-source
git_branch_checkout("ja-source")
system(glue::glue(
  "rsync -av \\
  --update \\
  --exclude '_locale*' --exclude '.git*' --exclude '_site' \\
  --exclude 'renv' --exclude 'working' --exclude 'po' \\
  --exclude '*_cache' --exclude '.Rhistory' --exclude '.Rproj.user' \\
  _locale/ja/ ./"
))
git_commit_all("Update JA translation")
git_branch_checkout("main")
