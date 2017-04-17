(in-package :jsc-tests)

(def-suite :jsc-object)
(in-suite :jsc-object)

(test ast-object
  (let ((tst (jsc:js-ast-from-string "{ x: 1 }")))
    (is (equal tst `((:obj (((:ident "x") (:num "1")))))))))

(test ast-object-2
  (let ((tst (jsc:js-ast-from-string "{ \"x\": 1, \"y\": 2 }")))
    (is (equal tst `((:obj (((:str "x") (:num "1"))
                            ((:str "y") (:num "2")))))))))
