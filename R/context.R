# context accessors -------------------------------------------------------

context_env <- new_environment()
context_poke <- function(name, value) {
  old <- context_env[[name]]
  context_env[[name]] <- value
  old
}
context_peek_bare <- function(name) {
  context_env[[name]]
}
context_peek <- function(name, fun, location = "funs verbs") {
  context_peek_bare(name) %||%
    abort(glue("`{fun}` must only be used inside {location}."))
}
context_local <- function(name, value, frame = caller_env()) {
  old <- context_poke(name, value)
  expr <- expr(on.exit(context_poke(!!name, !!old), add = TRUE))
  eval_bare(expr, frame)
}
