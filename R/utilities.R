#' Convert a Unix time to a timestamp
#'
#' @param posix a vector of integer numbeer of seconds since Unix Epoch
#'
#' @return a POSIXct object
#' @export
#'
#' @examples
#' fromUnixTime(1501668000)
#'
fromUnixTime <- function(posix) {
  as.POSIXct(posix, origin = "1970-01-01", tz = "UTC")
}

