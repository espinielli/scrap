#' Extract nth (or multiple sub-) group
#'
#' Inspired by this [SO answer](https://stackoverflow.com/a/46073918).
#'
#' @param x grouped data frame
#' @param n index(es) of the group(s) to extract
#'
#' @return subset of groups from the input dataframe
#' @export
#'
#' @importFrom rlang .data
#'
#' @importFrom magrittr %>%
#'
#' @examples
#' \dontrun{
#' # extract first group
#' mtcars %>% group_by(cyl) %>% nth_group(1)
#'
#' # extract first and third group
#' mtcars %>% group_by(cyl) %>% nth_group(c(1,3))
#' }
#'
nth_group <- function(x, n) {
  x %>%
    dplyr::select(dplyr::group_cols()) %>%
    dplyr::distinct %>%
    dplyr::ungroup %>%
    dplyr::slice(n) %>%
    { dplyr::semi_join(x, .data)}
}
