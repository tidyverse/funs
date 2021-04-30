#' Find all values within a range
#'
#' This is a shortcut for `x >= left & x <= right`,
#'
#' @param x A vector of values
#' @param left,right Boundary values.
#' @param bounds One of \verb{[]}, \verb{[)}, \verb{()}, or `()`, which defines whether the
#'   boundary is inclusive (`[` / `]`) or exclusive (`(` / `)`).
#' @return A logical vector. The length will be determined by the common
#'   length of `x`, `left`, and `right`.
#' @export
#' @examples
#' between(c(1:10, NA), 4, 6)
#' between(letters, "d", "j")
#'
#' today <- Sys.Date()
#' between(today, today - 1, today + 1)
between <- function(x, left, right, bounds = "[]") {
  bounds <- switch(bounds,
    "[]" = list(`>=`, `<=`),
    "[)" = list(`>=`, `<`),
    "(]" = list(`>`, `<=`),
    "()" = list(`>`, `<`),
    abort("Unknown `bounds` specification.")
  )

  bounds[[1]](vec_compare(x, left), 0) &
    bounds[[2]](vec_compare(x, right), 0)
}
