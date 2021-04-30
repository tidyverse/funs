#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME:
 Check these declarations against the C/Fortran source code.
 */

/* .Call calls */
extern SEXP funs_cumall(SEXP);
extern SEXP funs_cumany(SEXP);

static const R_CallMethodDef CallEntries[] = {
  {"funs_cumall", (DL_FUNC) &funs_cumall, 1},
  {"funs_cumany", (DL_FUNC) &funs_cumany, 1},
  {NULL, NULL, 0}
};

void R_init_funs(DllInfo *dll)
{
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
