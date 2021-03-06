% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/use_db_function.R
\name{use_db_function}
\alias{use_db_function}
\title{Create a function to access PRISME's Oracle DB}
\usage{
use_db_function(name, open = rlang::is_interactive())
}
\arguments{
\item{name}{name of the function (and R file)}

\item{open}{Open the newly created file for editing? Happens in RStudio, if
applicable, or via \code{\link[utils:file.edit]{utils::file.edit()}} otherwise.}
}
\description{
Create a function to access PRISME's Oracle DB
}
\examples{
\dontrun{
use_db_function("export_flows")
}
}
