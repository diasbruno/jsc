(in-package :jsc)

(defun ast-build-array (stream)
  "Build the array ast with STREAM."
  `(:arr ,(loop
             :for (ty token) := (multiple-value-list (token-next stream))
             :while (stop-when-char token "]")
             :nconc (prog1 (list (ast-for stream ty token))
                      (token-skip stream #\,)))))
