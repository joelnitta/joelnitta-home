# R script to translate the website contents from Japanese (JA) to English (EN)
# Actual translation takes place in PO files; everything else is automated

library(dovetail)
library(quarto)
library(gert)
source(here::here("R/functions.R"))

# Create / update PO files
md2po(md_in = "_quarto.yml", po = "po/ja/_quarto.po")
md2po(md_in = "index.qmd", po = "po/ja/index.po")
md2po(md_in = "software.qmd", po = "po/ja/software.po")
md2po(md_in = "blog.qmd", po = "po/ja/blog.po")
md2po(md_in = "publications.qmd", po = "po/ja/publications.po")

# (edit PO files)

# Switch to ja-source branch (source code for JA website)
git_branch_checkout("ja-source")

# Translate MD files **in place**
po2md(md_in = "_quarto.yml", po = "po/ja/_quarto.po", md_out = "_quarto.yml")
po2md(md_in = "index.qmd", po = "po/ja/index.po", md_out = "index.qmd")
po2md(md_in = "software.qmd", po = "po/ja/software.po", md_out = "software.qmd")
po2md(md_in = "blog.qmd", po = "po/ja/blog.po", md_out = "blog.qmd")
po2md(md_in = "publications.qmd", po = "po/ja/publications.po", md_out = "publications.qmd") # nolint

# Make any manual tweaks needed to translated docs

# Optional: render translated webpage for local viewing
quarto_preview()
quarto_preview_stop()

# Commit changes to JA branch
git_commit_all("Translate to JA")

# Push to the remote
git_push("origin")

# Change back to main
git_branch_checkout("main")
