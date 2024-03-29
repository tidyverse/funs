% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/between.R
\name{between}
\alias{between}
\title{Detect if values fall within a range}
\usage{
between(x, left, right, ..., bounds = "[]")
}
\arguments{
\item{x}{A vector}

\item{left, right}{Boundary values. Both \code{left} and \code{right} are recycled to
the size of \code{x} and are cast to the type of \code{x}.}

\item{...}{These dots are for future extensions and must be empty.}

\item{bounds}{One of \verb{"[]"}, \verb{"[)"}, \verb{"(]"}, or \verb{"()"},
which defines whether the boundary is inclusive (with \code{[} or \verb{]}) or
exclusive (with \code{(} or \verb{)}).}
}
\value{
A logical vector the same size as \code{x}.
}
\description{
This is essentially a shortcut for \code{x >= left & x <= right}, but it also
retains the size of \code{x} and casts both \code{left} and \code{right} to the type of
\code{x} before making the comparison.
}
\examples{
between(c(1:10, NA), 4, 6)
between(letters, "d", "j")

today <- Sys.Date()
between(today, today - 1, today + 1)
}
