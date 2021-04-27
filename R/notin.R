#' The negation of the value matching operator
#'
#' @param x     The values to be matched
#' @param table The values to not be matched against
#'
#' @return A logical vector, negation of the `%in%` operator.
#' @export
#'
#' @examples
#' \dontrun{
#' 1:5 %ni% c(1,3,5)
#' }
`%ni%` <- function(x, table) !`%in%`(x, table)
