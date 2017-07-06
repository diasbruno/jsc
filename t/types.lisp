(in-package :jsc-tests)

(def-suite :jsc-types)
(in-suite :jsc-types)

(test ast-join-empty-items
  (let* ((a (jsc-ast:ast-new nil nil))
         (b (jsc-ast:ast-new nil nil)))
    (is (equalp (jsc-ast:ast-join-item a b)
                (jsc-ast:ast-new nil nil)))))

(test ast-join-items-a-is-empty
  (let* ((a (jsc-ast:ast-new nil nil))
         (b (jsc-ast:ast-new nil 'b)))
    (is (equalp (jsc-ast:ast-join-item a b)
                (jsc-ast:ast-new nil 'b)))))

(test ast-join-items-b-is-empty
  (let* ((a (jsc-ast:ast-new nil (list 'a)))
         (b (jsc-ast:ast-new nil nil)))
    (is (equalp (jsc-ast:ast-join-item a b)
                (jsc-ast:ast-new nil (list 'a))))))

(test ast-join-items
  (let* ((a (jsc-ast:ast-new nil (list 'a)))
         (b (jsc-ast:ast-new nil (list 'b))))
    (is (equalp (jsc-ast:ast-join-item a b)
                (jsc-ast:ast-new nil '(a (b)))))))
