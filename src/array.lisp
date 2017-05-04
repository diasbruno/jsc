(in-package :jsc)

(defun ast-build-array (stream)
  "Build the array ast with STREAM."
  `(:arr ,(loop
             :for stmt := (token-next stream)
             :while (stop-when-char stmt "]")
             :nconc (prog1 (list (ast-acquire stream stmt))
                        (token-skip stream #\,)))))
