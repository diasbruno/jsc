(in-package :jsc-tests)

(def-suite :jsc-scopes)
(in-suite :jsc-scopes)

(test ast-scope-body
  (let* ((st (make-string-input-stream "{ a = 1; }"))
         (tst (jsc:ast-curly-scope (jsc:ast-new st nil))))
    (is (equal (jsc-ast:ast-state-tree tst)
               `(:curly-scope (:ASSIGNMENT (:IDENT "a") (:NUM "1")))))))

(test ast-scope-prentesis
  (let* ((st (make-string-input-stream "()"))
         (tst (jsc:ast-parentesis-scope (jsc:ast-new st nil))))
    (is (equal (jsc-ast:ast-state-tree tst)
               `(:parentesis-scope)))))

(test ast-scope-prentesis-with-var
  (let* ((st (make-string-input-stream "(a)"))
         (tst (jsc:ast-parentesis-scope (jsc:ast-new st nil))))
    (is (equal (jsc-ast:ast-state-tree tst)
               `(:parentesis-scope (:ident "a"))))))

(test ast-scope-prentesis-with-2-var
  (let* ((st (make-string-input-stream "(a, b)"))
         (tst (jsc:ast-parentesis-scope (jsc:ast-new st nil))))
    (is (equal (jsc-ast:ast-state-tree tst)
               `(:parentesis-scope (:ident "a") (:ident "b"))))))

(test ast-scope-prentesis-with-expr
  (let* ((st (make-string-input-stream "(a + 1)"))
         (tst (jsc:ast-parentesis-scope (jsc:ast-new st nil))))
    (is (equal (jsc-ast:ast-state-tree tst)
               `(:parentesis-scope (:addition (:ident "a") (:num "1")))))))

(test ast-scope-prentesis-with-expr-and-num
  (let* ((st (make-string-input-stream "(a + 1, 4)"))
         (tst (jsc:ast-parentesis-scope (jsc:ast-new st nil))))
    (is (equal (jsc-ast:ast-state-tree tst)
               `(:parentesis-scope (:addition (:ident "a") (:num "1"))
                                   (:num "4"))))))

(test ast-scope-prentesis-with-2-expr
  (let* ((st (make-string-input-stream "(a + 1, 4 + 5 + b)"))
         (tst (jsc:ast-parentesis-scope (jsc:ast-new st nil))))
    (is (equal (jsc-ast:ast-state-tree tst)
               `(:parentesis-scope (:addition (:ident "a") (:num "1"))
                                   (:addition (:num "4") 
                                              (:addition (:num "5") (:ident "b"))))))))
