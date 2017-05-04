(in-package :jsc-tests)

(def-suite :jsc-number)
(in-suite :jsc-number)

(test #:ast-number
  (let ((tst (jsc:ast-from-string "1")))
    (is (equal tst `((:num "1"))))))
