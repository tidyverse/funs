check_column <- function(x, chops) {
  if (is_symbol(x)) {
    chops[[as.character(x)]]
  }
}

check_scalar_logical <- function(x, default = FALSE) {
  if (is_scalar_logical(x)) {
    x
  } else if(is.null(x)) {
    default
  }
}

match_mean <- function(x, ...) {
  call <- match.call()
  chops_env <- peek_chops()

  x <- check_column(call$x, chops_env)
  na.rm <- check_scalar_logical(call$na.rm, FALSE)

  if (!is.null(x) && !is.null(na.rm)) {
    grouped_mean(x, na.rm = na.rm)
  }
}

match_n <- function(...) {
  if (dots_n(...) == 0) {
    chops_env <- peek_chops()

    new_list_of(
      as.list(list_sizes(parent.env(chops_env)[[".indices"]])),
      ptype = integer()
    )
  }
}

match_hybrid <- function(expr) {
  eval_bare(match.call()$expr, peek_chops())
}

#' @export
hybrid <- function(x) x

delayedAssign("hybrid_functions", list(
  mean = list(target = base::mean, match = match_mean),
  n = list(target = dplyr::n, match = match_n),
  hybrid = list(target = hybrid, match = match_hybrid)
))

peek_chops <- function() {
  context_peek("chops", "peek_chops()")
}
local_chops <- function(x, frame = caller_env()) {
  context_local("chops", x, frame = frame)
}

#' @export
eval_hybrid <- function(quo, chops) {
  expr <- quo_get_expr(quo)
  if (!is_call(expr)) return(NULL)

  local_chops(chops)

  # the function we meant to call
  fn_meant <- eval_bare(node_car(expr),
    env(quo_get_env(quo), hybrid = hybrid, `::` = `::`, `:::` = `:::`)
  )

  # hunt for an hybrid matcher for it
  fn_hybrid <- NULL
  for (fn in hybrid_functions) {
    if (identical(fn_meant, fn$target)) {
      fn_hybrid <- fn$match
      break
    }
  }

  # if we found one, try to call it, but it will however
  # perform its own validation of inputs before calling an
  # actual grouped_*() function
  res <- NULL
  if (!is.null(fn_hybrid)) {
    expr <- node_poke_car(expr, fn_hybrid)
    res <- eval_bare(expr)
  }

  if (!is.null(res) && is.null(attr(res, "ptype"))) {
    attr(res, "ptype") <- vec_ptype_common(!!!res)
  }
  res
}
