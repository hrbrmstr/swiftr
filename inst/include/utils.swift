
extension SEXP {

  var count: R_len_t {
    Rf_length(self)
  }

  var typeOf: SEXPTYPE {
    SEXPTYPE(TYPEOF(self))
  }

  var isSTRING: Bool {
    self.typeOf == STRSXP
  }

}

extension String {

  init?(_ sexp: SEXP) {
    if ((sexp != R_NilValue) && (Rf_length(sexp) == 1)) {
      switch (TYPEOF(sexp)) {
      case STRSXP: self = String(cString: R_CHAR(STRING_ELT(sexp, 0)))
      default: return(nil)
      }
    } else {
      return(nil)
    }
  }

}

extension Array where Element == String {

  init?(_ sexp: SEXP) {
    if (sexp.isSTRING) {
      var val : [String] = [String]()
      val.reserveCapacity(Int(sexp.count))
      for idx in 0..<sexp.count {
        val.append(String(cString: R_CHAR(STRING_ELT(sexp, R_xlen_t(idx)))))
      }
      self = val
    } else {
      return(nil)
    }
  }

  var SEXP: SEXP? {
    let charVec = Rf_protect(Rf_allocVector(SEXPTYPE(STRSXP), count))
    defer { Rf_unprotect(1) }
    for (idx, elem) in enumerated() { SET_STRING_ELT(charVec, idx, Rf_mkChar(elem)) }
    return(charVec)
  }

}


