(in-package :jsc)

(defun js-ast-process-key-value (stream)
  "Get the pair of key/value from STREAM."
  (assert (string= ":" (cadr (js-token-next stream))))
  (js-ast-acquire stream (js-token-next stream)))

(defun js-ast-build-obj (stream)
  "Real build the object with STREAM."
  (loop
     :for stmt := (js-token-next stream)
     :while (js-stop-when-char stmt "}")
     :collect (when (js-ast-object-key-p stmt)
                (js-token-skip stream #\,)
                (list stmt (js-ast-process-key-value stream)))))

(defun js-ast-build-object (stream)
  "Build the object ast with STREAM."
  `(:obj ,(remove-if #'null (js-ast-build-obj stream))))
