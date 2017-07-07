(in-package :jsc-tests)

(def-suite :jsc-types)
(in-suite :jsc-types)

(test ast-join-empty-trees
  (let* ((a (jsc-ast:ast-new nil nil))
         (b (jsc-ast:ast-new nil nil)))
    (is (equalp (jsc-ast:ast-join-trees a b)
                (jsc-ast:ast-new nil nil)))))

(test ast-join-trees-a-is-empty
  (let* ((a (jsc-ast:ast-new nil nil))
         (b (jsc-ast:ast-new nil 'b)))
    (is (equalp (jsc-ast:ast-join-trees a b)
                (jsc-ast:ast-new nil 'b)))))

(test ast-join-trees-b-is-empty
  (let* ((a (jsc-ast:ast-new nil '(a)))
         (b (jsc-ast:ast-new nil nil)))
    (is (equalp (jsc-ast:ast-join-trees a b)
                (jsc-ast:ast-new nil '(a))))))

(test ast-join-trees
  (let* ((a (jsc-ast:ast-new nil (list 'a)))
         (b (jsc-ast:ast-new nil (list 'b))))
    (is (equalp (jsc-ast:ast-join-trees a b)
                (jsc-ast:ast-new nil '(a (b)))))))
