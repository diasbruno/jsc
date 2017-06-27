(in-package :jsc-tests)

(def-suite :jsc-object)
(in-suite :jsc-object)

;; es2015

(test ast-object-empty
  (let ((tst (jsc:ast-from-string "{}")))
    (is (equal tst `((:obj nil))))))

(test ast-object-empty-2
  (let ((tst (jsc:ast-from-string "{ }")))
    (is (equal tst `((:obj nil))))))

(test ast-object-single-pair
  (let ((tst (jsc:ast-from-string "{ x: 1 }")))
    (is (equal tst `((:obj (((:ident "x") (:num "1")))))))))

(test ast-object-single-pair-2
  (let ((tst (jsc:ast-from-string "{x: 1}")))
    (is (equal tst `((:obj (((:ident "x") (:num "1")))))))))

(test ast-object-single-pair-3
  (let ((tst (jsc:ast-from-string "{x:1}")))
    (is (equal tst `((:obj (((:ident "x") (:num "1")))))))))

(test ast-object-many-pairs
  (let ((tst (jsc:ast-from-string "{ \"x\": 1, \"y\": 2 }")))
    (is (equal tst `((:obj (((:str "x") (:num "1"))
                            ((:str "y") (:num "2")))))))))

(test ast-object-many-pairs-2
  (let ((tst (jsc:ast-from-string "{ \"x\": 1,\"y\": 2 }")))
    (is (equal tst `((:obj (((:str "x") (:num "1"))
                            ((:str "y") (:num "2")))))))))

;; es6

(test ast-object-scoped-var
  (let ((tst (jsc:ast-from-string "{ x }")))
    (is (equal tst `((:obj (((:ident "x") :scoped-var))))))))

(test ast-object-scoped-var-2
  (let ((tst (jsc:ast-from-string "{ x, y }")))
    (is (equal tst `((:obj (((:ident "x") :scoped-var)
                            ((:ident "y") :scoped-var))))))))

(test ast-object-scoped-var-mixed
  (let ((tst (jsc:ast-from-string "{ x, y: 1 }")))
    (is (equal tst `((:obj (((:ident "x") :scoped-var)
                            ((:ident "y") (:num "1")))))))))
