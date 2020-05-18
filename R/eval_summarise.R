#' @importFrom dplyr peek_mask
hybrid_functions <- env(
  empty_env(),
  mean = function(x, ...) {
    call <- match.call()
    mask <- peek_mask()
    vars <- mask$current_vars()

    stopifnot(is_symbol(call$x) && as_string(call$x) %in% vars)
    if (identical(names(call), c("", "x"))) {
      funs::grouped_mean(x, na.rm = TRUE)
    } else if(identical(names(call), c("", "x", "na.rm"))) {
      na.rm <- call$na.rm
      stopifnot(is_scalar_logical(na.rm))
      funs::grouped_mean(x, na.rm = na.rm)
    }
  },
  "$" = `$`
)

#' eval summarise
#'
#' @param expr ...
#' @param mask ...
#' @export
eval_summarise <- function(expr) {
  result <- NULL
  mask <- peek_mask()
  if (is_call(expr, "hybrid")) {
    fn <- new_function(mask$args(), node_cadr(expr))
  } else if(is_call(expr, "n", n = 0)){
    fn <- function() list_sizes(mask$get_rows())
  } else {
    fn <- new_function(mask$args(), expr, env = hybrid_functions)
  }

  result <- fn()

  if (!is.null(result) && !inherits(result, "hybrid_result")) {
    if (vec_size(result) != length(mask$get_rows())) {
      abort("incompatible sizes")
    }
    result <- structure(
      list(x = result),
      class = "hybrid_result"
    )
  }
  result
}
