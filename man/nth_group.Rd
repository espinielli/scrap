% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/nth_group.R
\name{nth_group}
\alias{nth_group}
\title{Extract nth (or multiple sub-) group}
\usage{
nth_group(x, n)
}
\arguments{
\item{x}{grouped data frame}

\item{n}{index(es) of the group(s) to extract}
}
\value{
subset of groups from the input dataframe
}
\description{
Inspired by this \href{https://stackoverflow.com/a/46073918}{SO answer}.
}
\examples{
\dontrun{
# extract first group
mtcars \%>\% group_by(cyl) \%>\% nth_group(1)

# extract first and third group
mtcars \%>\% group_by(cyl) \%>\% nth_group(c(1,3))
}

}
