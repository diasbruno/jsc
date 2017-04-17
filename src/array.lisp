(in-package :jsc)

(defun js-ast-build-array (stream)
  "Build the array ast with STREAM."
  `(:arr ,(loop
             :for stmt := (js-token-next stream)
             :while (js-stop-when-char stmt "]")
             :nconc (prog1 (list (js-ast-acquire stream stmt))
                        (js-token-skip stream #\,)))))
