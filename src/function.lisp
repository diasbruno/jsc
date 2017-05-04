(in-package :jsc)

(defun ast-build-function (stream)
  "Build the ast for a function with STREAM."
  (let* ((maybe-name (token-next stream))
         (name (if (eq (car maybe-name) :grp)
                   nil
                   (cadr maybe-name))))
    `(:fn ,name ,(ast-parentesis-expr stream) ,(ast-body stream))))
