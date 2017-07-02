(in-package :jsc-ast)

(defun ast-build-array (stream)
  "Build the array ast with STREAM."
  `(:arr ,(loop
             :for (ty token) := (multiple-value-list (token-next stream))
             :while (stop-when-char token "]")
             :collect (prog1 (ast-for stream ty token)
                        (token-skip stream #\,)))))
