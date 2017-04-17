(in-package :jsc-tests)

(def-suite :jsc-string)
(in-suite :jsc-string)

(test #:ast-string
  (let ((tst (jsc:js-ast-from-string "\"test string\"")))
    (is (equal tst `((:str "test string"))))))

(test #:ast-string-2
  (let ((tst (jsc:js-ast-from-string "\'test string\'")))
    (is (equal tst `((:str "test string"))))))
