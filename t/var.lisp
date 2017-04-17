(in-package :jsc-tests)

(def-suite :jsc-var)
(in-suite :jsc-var)

(test ast-var
  (let ((tst (jsc:js-ast-from-string "var x = \"a\";")))
    (is (equal tst `((:var (((:ident "x") (:str "a")))))))))

(test ast-var-2
  (let ((tst (jsc:js-ast-from-string "var x = 1, y = 2;")))
    (is (equal tst `((:var (((:ident "x") (:num "1"))
                            ((:ident "y") (:num "2")))))))))

(test ast-var-const
  (let ((tst (jsc:js-ast-from-string "const x = \"a\";")))
    (is (equal tst `((:const (((:ident "x") (:str "a")))))))))

(test ast-var-let
  (let ((tst (jsc:js-ast-from-string "let x = \"a\";")))
    (is (equal tst `((:let (((:ident "x") (:str "a")))))))))
