(in-package :jsc)

(defun ast-build-function (stream)
  "Build the ast for a function with STREAM."
  (read-spaces stream)
  `(:fn ,(if (eq (peek-char nil stream nil) #\()
             nil
             (multiple-value-bind (ty maybe-name)
                 (token-next stream)
               maybe-name))
        ,(ast-parentesis-expr stream)
        ,(ast-body stream)))
