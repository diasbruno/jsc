(in-package :jsc-tests)

(def-suite :jsc-types)
(in-suite :jsc-types)

(test ast-join-items
  (let* ((a (jsc-ast:ast-new nil nil nil))
         (b (jsc-ast:ast-new nil nil nil)))
    (is (equal (jsc-ast:ast-join-item a b)
               (list nil)))))
