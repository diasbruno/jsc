(in-package :jsc)

(defun ast-process-key-value (stream)
  "Get the pair of key/value from STREAM."
  (assert (string= ":" (cadr (token-next stream))))
  (ast-for stream (token-next stream)))

(defun ast-build-obj (stream)
  "Real build the object with STREAM."
  (loop
     :for stmt := (token-next stream)
     :while (stop-when-char stmt "}")
     :collect (when (ast-object-key-p stmt)
                (token-skip stream #\,)
                (list stmt (ast-process-key-value stream)))))

(defun ast-build-object (stream)
  "Build the object ast with STREAM."
  `(:obj ,(remove-if #'null (ast-build-obj stream))))
