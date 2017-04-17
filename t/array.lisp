(in-package :jsc-tests)

(def-suite :jsc-array)
(in-suite :jsc-array)

(test ast-array
  (let ((tst (jsc:js-ast-from-string "[1, 2]")))
    (is (equal tst `((:arr ((:num "1") (:num "2"))))))))
