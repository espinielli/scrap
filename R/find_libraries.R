# find files that might have library() or pkg::func() notation
list_files_to_inspect <- function(
  path = ".",
  pattern = "\\.Rmd$|\\.qmd$|\\.r$|\\.R$",
  recursive = TRUE
) {
  list.files(
    path = path,
    pattern = pattern,
    full.names = TRUE,
    recursive = recursive
  )
}

#' Discover R libraries used in project
#'
#' Inspired by [Lisa DeBruine's gist](https://gist.github.com/debruine/55bc4a23e1ab9d378e8cdcd3e9cabaf5)
#'
#' @param path the root of the project to look for
#' @param pattern the file types to analyse (default: .R, .r, .qmd, .Rmd)
#' @param recursive search files recursively (default: TRUE)
#'
#' @family libraries
#'
#' @returns list of library names
#' @export
#'
#' @examples
#' \dontrun{
#' find_libraries(".")
#' }
discover_libraries <- function(
  path = ".",
  pattern = "\\.Rmd$|\\.qmd$|\\.r$|\\.R$",
  recursive = TRUE
) {
  # args <- list2(...)
  contents <- list_files_to_inspect(
    path = path,
    pattern = pattern,
    recursive = recursive
  ) |>
    purrr::map(readLines)
  libs <- look_for_library(contents)
  reqs <- look_for_require(contents)
  pkgs <- look_for_pkgfun(contents)

  c(libs, reqs, pkgs) |>
    sort() |>
    unique() |>
    setdiff(c(NA, "")) # get rid of NA or ""
}

# look for library function
look_for_library <- function(contents) {
  lib_pattern <- "(?<=library\\()[A-Za-z0-9_\\.\'\"]+(?=\\))"
  purrr::map(
    contents,
    stringr::str_extract,
    pattern = lib_pattern
  ) |>
    unlist() |>
    unique() |>
    gsub(pattern = "\"|\'", replacement = "", x = _) |>
    trimws() |>
    setdiff(c(NA, ""))
}

# look for require function
look_for_require <- function(contents) {
  req_pattern <- "(?<=require\\()[A-Za-z0-9_\\.\'\"]+(?=\\))"
  purrr::map(
    contents,
    stringr::str_extract,
    pattern = req_pattern
  ) |>
    unlist() |>
    unique() |>
    gsub(pattern = "\"|\'", replacement = "", x = _) |>
    trimws() |>
    setdiff(c(NA, ""))
}

# look for pkg::fnc() or pkg:::func()
# colon_pattern <- "[A-Za-z0-9_\\.]+(?=:{2,3}[A-Za-z0-9_\\.]+)"
# :{2,3} doesn't work with lookahead ^, so do 2 and 3 separately
look_for_pkgfun <- function(contents) {
  colon_pattern2 <- "[A-Za-z0-9_\\.]+(?=::[A-Za-z0-9_\\.]+)"
  colon2 <- purrr::map(
    contents,
    stringr::str_extract,
    pattern = colon_pattern2
  ) |>
    unlist()
  colon2 <- colon2[!is.na(colon2)]

  colon_pattern3 <- "[A-Za-z0-9_\\.]+(?=:::[A-Za-z0-9_\\.]+)"
  colon3 <- purrr::map(
    contents,
    stringr::str_extract,
    pattern = colon_pattern3
  ) |>
    unlist()

  c(colon2, colon3) |>
    unique() |>
    setdiff(c(NA, ""))
}


#' List libraries not installed
#'
#' @param libs name of libraries
#'
#' @returns names of libraries not installed in current system
#' @export
#'
#' @family libraries
#'
#' @examples
#' \dontrun{
#' list_missing_libraries(c("dplyr", "geobr"))
#' }
list_missing_libraries <- function(libs) {
  # missing <- setdiff(libs, installed.packages())
  pkg_locations <- purrr::map(libs, find.package, quiet = TRUE)
  missing_idx <- !purrr::map_dbl(pkg_locations, length)
  missing <- libs[missing_idx]

  missing
}
