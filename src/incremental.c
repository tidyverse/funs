#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

SEXP funs_incremental_any(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP out = PROTECT(Rf_allocVector(LGLSXP, n));

  int* p_x = LOGICAL(x);
  int* p_out = LOGICAL(out);

  // nothing to do as long as x[i] is FALSE
  R_xlen_t i = 0 ;
  for (; i < n; i++, ++p_x, ++p_out) {
    if (*p_x == FALSE) {
      *p_out = FALSE;
    } else {
      break;
    }
  }
  if (i < n) {
    // set to NA as long as x[i] is NA or FALSE
    for (; i < n; i++, ++p_x, ++p_out) {
      if (*p_x == TRUE) {
        break;
      }
      *p_out = NA_LOGICAL;
    }

    if (i < n) {
      // then if we are here, the rest is TRUE
      for (; i < n; i++, ++p_out) {
        *p_out = TRUE;
      }
    }

  }

  UNPROTECT(1);
  return out;
}

SEXP funs_incremental_all(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP out = PROTECT(Rf_allocVector(LGLSXP, n));
  int* p_x = LOGICAL(x);
  int* p_out = LOGICAL(out);

  // set out[i] to TRUE as long as x[i] is TRUE
  R_xlen_t i = 0 ;
  for (; i < n; i++, ++p_x, ++p_out) {
    if (*p_x == TRUE) {
      *p_out = TRUE;
    } else {
      break;
    }
  }
  if (i != n) {

    // set to NA as long as x[i] is NA or TRUE
    for (; i < n; i++, ++p_x, ++p_out) {
      if (*p_x == FALSE) {
        break;
      }
      *p_out = NA_LOGICAL;
    }

    // set remaining to FALSE
    if (i != n) {
      for (; i < n; i++, ++p_x, ++p_out) {
        *p_out = FALSE;
      }
    }

  }

  UNPROTECT(1);
  return out;
}
