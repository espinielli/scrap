#' Suppresses console output, including printing
#'
#' This is copied from package, `librarian`.
#'
#' @param expr (Expression) An expression to evaluate.
#'
#' @return Evaluates `expr`.
#' @export
#'
#' @md
shhh <- function(expr) {
  call <- quote(expr)

  invisible(
    utils::capture.output(
      out <-
        suppressWarnings(
          suppressMessages(
            suppressPackageStartupMessages(
              eval(call)))))
  )
  return(invisible(out))
}
