(in-package :jsc-tests)

(def-suite :jsc-string)
(in-suite :jsc-string)

(test ast-string
  (let ((tst (jsc:ast-from-string "\"test string\"")))
    (is (equalp (jsc:ast-state-tree (car tst))
                '(:str "test string")))))

(test ast-string-2
  (let ((tst (jsc:ast-from-string "\'test string\'")))
    (is (equalp (jsc:ast-state-tree (car tst))
                '(:str "test string")))))
