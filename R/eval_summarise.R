dummy <- function(class) {
  structure(list(), class = class)
}

column <- function() {
  dummy("column")
}

scalar_logical <- function(default) {
  default
}

scalar_integer <- function() {
  dummy("scalar_integer")
}

arg_match <- function(spec, given) {
  if (is_call(spec, "column") && is_symbol(given)) {
    dplyr::peek_mask()$resolve(as_string(given))
  } else if (is_call(spec, "scalar_logical")) {
    if (is_scalar_logical(given)) {
      given
    } else if (is.null(given)) {
      spec$default
    } else {
      abort(":shrug:")
    }
  } else if (is_call(spec, "scalar_integer")) {
    if (is_scalar_integerish(given)) {
      as_integer(given)
    } else {
      abort("unspecified argument")
    }
  } else if (identical(spec, NA)) {
    given %||% NA
  } else {
    abort(":no:")
  }
}

#' @importFrom glue glue
fun_matcher <- function(fn, grouped_fn, ...) {
  spec <- as.list(match.call())[-(1:3)]
  f <- function(...) {
    call <- as.list(match.call())[-1]

    # match spec and call together
    names <- names(spec)

    for(name in names) {
      spec[[name]] <- arg_match(spec[[name]], call[[name]])
    }

    eval_bare(expr(grouped_fn(!!!spec)))
  }
  formals(f) <- formals(grouped_fn)
  attr(f, "fn") <- fn
  f
}

delayedAssign("hybrid_functions", env(
  empty_env(),

  mean = fun_matcher(mean, grouped_mean, x = column(), na.rm = scalar_logical(default = FALSE)),

  sum  = fun_matcher(sum , grouped_sum , x = column(), na.rm = scalar_logical(default = FALSE)),
  var  = fun_matcher(var , grouped_var , x = column(), na.rm = scalar_logical(default = FALSE)),
  sd   = fun_matcher(sd  , grouped_sd  , x = column(), na.rm = scalar_logical(default = FALSE)),

  min  = fun_matcher(min , grouped_min , x = column(), na.rm = scalar_logical(default = FALSE)),
  max  = fun_matcher(max , grouped_max , x = column(), na.rm = scalar_logical(default = FALSE)),

  first = fun_matcher(dplyr::first, grouped_first, x = column(), default = NA),
  last = fun_matcher(dplyr::last, grouped_last, x = column(), default = NA),
  nth = fun_matcher(dplyr::nth, grouped_nth, x = column(), n = scalar_integer(), default = NA),

  lead = fun_matcher(dplyr::lead, grouped_lead, x = column(), n = scalar_integer(), default = NA),

  "$" = `$`
))

new_hybrid_result <- function(x, sizes = NULL) {
  # TODO: some checking about sizes, maybe wrt the current mask
  if (!inherits(x, "hybrid_result")) {
    x <- structure(
      list(x = x, sizes = sizes),
      class = "hybrid_result"
    )
  }
  x
}

#' @export
hybrid <- function(x) x

#' eval summarise
#'
#' @param expr ...
#' @param mask ...
#' @export
eval_summarise <- function(quo) {
  expr <- quo_get_expr(quo)
  result <- NULL
  mask <- dplyr::peek_mask()

  if (is_call(expr, "hybrid")) {
    fn <- new_function(mask$args(), node_cadr(expr))
  } else if(is_call(expr, "n", n = 0)){
    fn <- function() list_sizes(mask$get_rows())
  } else {
    fn_symbol <- node_car(expr)
    fn_meant <- eval_bare(fn_symbol, caller_env(3))
    fn_hybrid <- attr(eval_bare(fn_symbol, hybrid_functions), "fn")
    if (!identical(fn_meant, fn_hybrid)) {
      abort("No match")
    }

    fn <- new_function(mask$args(), expr, env = hybrid_functions)
  }

  new_hybrid_result(fn())
}

#' For testing purpuses for now
#'
#' @examples
#' df <- dplyr::group_by(data.frame(x = 1:4, y = c(1,1,2,2)), y)
#' df %>% jog(mean(x))
#' df %>% jog(sum(x))
#' df %>% jog(var(x))
#' df %>% jog(sd(x))
#'
#' df %>% jog(first(x))
#' @export
jog <- function(.data, quo) {
  e <- env(asNamespace("dplyr"), caller = environment(), .data = .data)
  eval_bare(expr(DataMask$new(.data, caller)), env = e)
  eval_summarise(enquo(quo))
}
