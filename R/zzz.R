#' @import cli
NULL

.onLoad <- function(libname, pkgname) {
  run_on_load()
}

on_load(local_use_cli())
