(in-package :jsc-tests)

(def-suite :jsc-scopes)
(in-suite :jsc-scopes)

(test ast-scope-body
  (let ((tst (jsc:ast-body (make-string-input-stream "{ a = 1; }"))))
    (is (equal tst '()))))
