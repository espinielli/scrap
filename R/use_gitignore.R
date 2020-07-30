#' Create a .gitignore for R projects
#'
#' The content of the .gitignore is from
#' https://github.com/github/gitignore/ for
#' R, macOS, Windows and Linux
#'
#' @export
#'
#' @examples
#' \dontrun{
#' use_gitignore()
#' }
use_gitignore <- function() {
  usethis::use_template("gitignore", save_as = paste0(".gitignore"), package = "scrap")
}
