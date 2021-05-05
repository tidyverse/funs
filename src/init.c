#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME:
 Check these declarations against the C/Fortran source code.
 */

/* .Call calls */
extern SEXP funs_incremental_any(SEXP);
extern SEXP funs_incremental_all(SEXP);

static const R_CallMethodDef CallEntries[] = {
  {"funs_incremental_any", (DL_FUNC) &funs_incremental_any, 1},
  {"funs_incremental_all", (DL_FUNC) &funs_incremental_all, 1},
  {NULL, NULL, 0}
};

void R_init_funs(DllInfo *dll)
{
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
