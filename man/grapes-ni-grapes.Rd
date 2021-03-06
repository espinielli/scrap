% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/notin.R
\name{\%ni\%}
\alias{\%ni\%}
\title{The negation of the value matching operator}
\usage{
x \%ni\% table
}
\arguments{
\item{x}{The values to be matched}

\item{table}{The values to not be matched against}
}
\value{
A logical vector, negation of the \code{\%in\%} operator.
}
\description{
The negation of the value matching operator
}
\examples{
\dontrun{
1:5 \%ni\% c(1,3,5)
}
}
