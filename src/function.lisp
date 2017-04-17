(in-package :jsc)

(defun js-ast-build-function (stream)
  "Build the ast for a function with STREAM."
  (let* ((maybe-name (js-token-next stream))
         (name (if (eq (car maybe-name) :grp)
                   nil
                   (cadr maybe-name))))
    `(:fn ,name ,(js-ast-parentesis-expr stream) ,(js-ast-body stream))))
