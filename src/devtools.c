#include <R.h>
#include <Rdefines.h>

SEXP nsreg() {
  return R_NamespaceRegistry;
}

#ifdef _WIN32

int isReparsePoint(const wchar_t* name) {
    DWORD res = GetFileAttributesW(name);
    if (res == INVALID_FILE_ATTRIBUTES) {
      warning(
        "cannot get info on '%ls', reason '%s'",
        name,
        formatError(GetLastError())
      );
	    return 0;
    }
    // printf("%ls: %x\n", name, res);
    return res & FILE_ATTRIBUTE_REPARSE_POINT;
}

#endif

SEXP isReparsePoint(SEXP path) {

  #ifdef _WIN32
  R_xlen_t n = xlength(path);
  SEXP output = PROTECT(allocVector(LGLSXP, n));
  for (R_xlen_t i = 0; i < n; i++) {
    output[i] = isReparsePointImpl(CHAR(STRING_ELT(path, i)));
  }
  UNPROTECT(1);
  return output;

  #else

  R_xlen_t n = xlength(path);
  SEXP output = PROTECT(allocVector(LGLSXP, n));
  for (R_xlen_t i = 0; i < n; i++) {
    LOGICAL(output)[i] = FALSE;
  }
  UNPROTECT(1);
  return output;

  #endif

}
