#' Convert a Unix time to a timestamp
#'
#' @param posix a vector of integer number of seconds since Unix Epoch
#'
#' @return a POSIXct object
#' @seealso fromPosixTime
#' @export
#'
#' @examples
#' fromUnixTime(1501668000)
#'
fromUnixTime <- function(posix) {
  as.POSIXct(posix, origin = "1970-01-01", tz = "UTC")
}

#' Convert a Unix/Posix time to a timestamp
#'
#' @param posix a vector of integer numbers of seconds since Unix Epoch
#'
#' @return a POSIXct object
#' @export
#'
#' @examples
#' fromPosixTime(1501668000)
#'
fromPosixTime <- function(posix) {
  lubridate::as_datetime(posix)
}
