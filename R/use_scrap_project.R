use_scrap_project <- function() {
  dflow::use_dflow()
  usethis::use_directory("data")
  usethis::use_directory("data-raw")
  scrap::use_gitignore()
  usethis::use_readme_rmd(open = FALSE)
}
