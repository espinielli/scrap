#' Extract nth (or multiple sub-) group
#'
#' Inspired by this \href{https://stackoverflow.com/a/46073918}[SO answer].
#'
#' @param x grouped data frame
#' @param n index(es) of the group(s) to extract
#'
#' @return subset of groups from the input dataframe
#' @export
#'
#' @examples
#' # extract first group
#' mtcars %>% group_by(cyl) %>% nth_group(1)
#' # extract first and third group
#' mtcars %>% group_by(cyl) %>% nth_group(c(1,3))
nth_group <- function(x, n) {
  x %>%
    select(group_cols()) %>%
    distinct %>%
    ungroup %>%
    slice(n) %>%
    { semi_join(x, .)}
}
