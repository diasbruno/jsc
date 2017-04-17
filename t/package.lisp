(in-package :cl-user)
(defpackage jsc-tests
  (:use #:cl #:fiveam)
  (:export :run-all))
(in-package :jsc-tests)

(defun run-all ()
  (5am:run-all-tests))
