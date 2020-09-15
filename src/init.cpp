#include "funs.h"

static const R_CallMethodDef CallEntries[] = {
  {"funs_grouped_mean_dbl", (DL_FUNC)& funs_grouped_mean_dbl, 2},

  {NULL, NULL, 0}
};

extern "C" void R_init_funs(DllInfo* dll) {
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
