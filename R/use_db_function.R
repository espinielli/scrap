#' Create a function to access PRISME's Oracle DB
#'
#' @param name name of the function (and R file)
#' @inheritParams usethis::use_template
#'
#' @export
#'
#' @examples
#' \dontrun{
#' use_db_function("export_flows")
#' }
use_db_function <- function(name, open = rlang::is_interactive()) {
  usethis::use_template(
    "retrieve_from_oracle.R",
    paste0(name, ".md"),
    open = open)
}
