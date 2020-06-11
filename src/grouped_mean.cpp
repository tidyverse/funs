#include "funs.h"

double mean_dbl_narm(SEXP x) {
  R_xlen_t n_x = XLENGTH(x), m_x = n_x;

  long double res = 0.0;
  double* p_x = REAL(x);
  for (R_xlen_t j = 0; j < n_x; j++, ++p_x) {
    if (R_IsNA(*p_x)) {
      m_x--;
    } else {
      res += *p_x;
    }
  }
  if (m_x == 0) {
    res = R_NaN;
  } else {
    long double t = 0.0;
    p_x = REAL(x);
    for (R_xlen_t j = 0; j < n_x; j++, ++p_x) {
      t += R_IsNA(*p_x) ? 0.0 : (*p_x - res);
    }
    res += (t / m_x);
  }

  return (double)res;
}

double mean_dbl_nakeep(SEXP x) {
  R_xlen_t n_x = XLENGTH(x);
  if (n_x == 0) {
    return R_NaN;
  }

  long double res = 0.0;
  double* p_x = REAL(x);

  for (R_xlen_t j = 0; j < n_x; j++, ++p_x) {
    res += *p_x;
  }

  long double t = 0.0;
  p_x = REAL(x);
  for (R_xlen_t j = 0; j < n_x; j++, ++p_x) {
    t += *p_x - res;
  }
  res += (t / n_x);

  return (double)res;
}

SEXP grouped_mean_dbl(SEXP x, SEXP na_rm_) {
  bool na_rm = Rf_asLogical(na_rm_);
  R_xlen_t n = XLENGTH(x);
  SEXP res = PROTECT(Rf_allocVector(REALSXP, n));
  double* p_res = REAL(res);

  if (na_rm) {
    for (R_xlen_t i=0; i < n; i++, ++p_res) {
      *p_res = mean_dbl_narm(VECTOR_ELT(x, i));
    }
  } else {
    for (R_xlen_t i=0; i < n; i++, ++p_res) {
      *p_res = mean_dbl_nakeep(VECTOR_ELT(x, i));
    }
  }

  UNPROTECT(1);
  return res;
}
