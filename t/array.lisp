(in-package :jsc-tests)

(def-suite :jsc-array)
(in-suite :jsc-array)

(test ast-array
  (let ((tst (jsc:ast-from-string "[1, 2]")))
    (is (equal tst `((:arr ((:num "1") (:num "2"))))))))

(test ast-array-item
  (let ((tst (jsc:ast-from-string "[x]")))
    (is (equal tst `((:arr ((:expr ((:ident "x"))))))))))

(test ast-array-item-array
  (let ((tst (jsc:ast-from-string "[[x], 1]")))
    (is (equal tst `((:arr ((:arr ((:expr ((:ident "x")))))
                            (:num "1"))))))))
