(in-package :jsc-tests)

(def-suite :jsc-function)
(in-suite :jsc-function)

(test ast-function
  (let ((tst (jsc:js-ast-from-string
              "function add(x, y) { return x + y; }")))
    (is (equal tst `((:fn "add"
                          ((:ident "x") (:ident "y"))
                          ((:ret ((:ident "x") (:punct "+") (:ident "y"))))))))))

(test ast-function-2
  (let ((tst (jsc:js-ast-from-string
              "function add(y) { var a = 1; return a + y; }")))
    (is (equal tst `((:fn "add"
                          ((:ident "y"))
                          ((:var (((:ident "a") (:num "1"))))
                           (:ret ((:ident "a") (:punct "+") (:ident "y"))))))))))
