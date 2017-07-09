(in-package :jsc-tests)

(def-suite :jsc-expression)
(in-suite :jsc-expression)

(test ast-expression-assignment
  (let ((tst (jsc:ast-from-string "a = 1;")))
    (is (equal (jsc-ast:ast-state-tree (car tst))
               `(:assignment (:ident "a")
                             (:num "1"))))))

(test ast-expression-array-accessor
  (let ((tst (jsc:ast-from-string "a[0]")))
    (is (equal tst `((:expr ((:ident "a")
                             (:aaccessor (:num "0")))))))))

#|
(test ast-expression-object-accessor
  (let ((tst (jsc:ast-from-string "a.b")))
    (is (equal tst `((:expr ((:ident "a")
                             (:ident "b"))))))))

(test ast-expression-object-accessor-and-assignment
  (let ((tst (jsc:ast-from-string "a.b = 1")))
    (is (equal tst `((:assignment (:expr ((:ident "a")
                                          (:ident "b")))
                                  ((:num "1"))))))))

(test ast-expression-consecutive-object-accessor
  (let ((tst (jsc:ast-from-string "a.b.c.d")))
    (is (equal tst `((:expr ((:ident "a")
                             (:ident "b")
                             (:ident "c")
                             (:ident "d"))))))))

(test ast-expression-all-mixed
  (let ((tst (jsc:ast-from-string "a.b[0].c().d")))
    (is (equal tst `((:expr ((:ident "a")
                             (:ident "b")
                             (:aaccessor (:num "0"))
                             (:ident "c")
                             (:func-call nil)
                             (:ident "d"))))))))

(test ast-expression-all-mixed-with-assignment
  (let ((tst (jsc:ast-from-string "a.b[0].c().d = 1")))
    (is (equal tst `((:assignment
                       (:expr ((:ident "a")
                               (:ident "b")
                               (:aaccessor (:num "0"))
                               (:ident "c")
                               (:func-call nil)
                               (:ident "d")))
                       ((:num "1"))))))))

(test ast-expression-function-call
  (let ((tst (jsc:ast-from-string "a()")))
    (is (equal tst `((:expr ((:ident "a")
                             (:func-call nil))))))))
|#
