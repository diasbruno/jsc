(in-package :jsc-ast)

(defun ast-build-function (stream)
  "Build the ast for a function with STREAM."
  (read-spaces stream)
  `(:fn ,(if (eq (char-ahead stream) #\()
             nil
             (multiple-value-bind (ty maybe-name)
                 (token-next stream)
               maybe-name))
        ,(ast-parentesis-expr stream)
        ,(ast-body stream)))
