(in-package :jsc-tests)

(def-suite :jsc-scopes)
(in-suite :jsc-scopes)

(test ast-scope-body
  (let* ((st (make-string-input-stream "{ a = 1; }"))
         (tst (jsc:ast-body (jsc:ast-new st nil))))
    (is (equal (jsc:ast-state-stream (car tst))
               `(:curly-scope (:ASSIGNMENT (:IDENT "a") (:NUM "1")))))))
