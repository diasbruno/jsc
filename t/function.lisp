(in-package :jsc-tests)

(def-suite :jsc-function)
(in-suite :jsc-function)

(test ast-function
  (let ((tst (jsc:ast-from-string
              "function add(x, y) { return x + y; }")))
    (is (equal tst `((:fn "add"
                          ((:ident "x")
                           (:ident "y"))
                          ((:ret ((:addition (:expr ((:ident "x")))
                                             (:expr ((:ident "y")))))))))))))

(test ast-function-2
  (let ((tst (jsc:ast-from-string
              "function add(y) { var a = 1; return a + y; }")))
    (is (equal tst `((:fn "add"
                          ((:ident "y"))
                          ((:var (((:ident "a") (:num "1"))))
                           (:ret ((:addition (:expr ((:ident "a")))
                                             (:expr ((:ident "y")))))))))))))

(test ast-function-3
  (let ((tst (jsc:ast-from-string
              "function(y) { var a = 1; return a + y; }")))
    (is (equal tst `((:fn nil
                          ((:ident "y"))
                          ((:var (((:ident "a") (:num "1"))))
                           (:ret ((:addition (:expr ((:ident "a")))
                                             (:expr ((:ident "y")))))))))))))
