(in-package :jsc)

(defun ast-process-key-value (stream)
  "Get the pair of key/value from STREAM."
  (multiple-value-bind (ty token)
      (token-next stream)
    (progn
      (assert (string= ":" token))
      (multiple-value-bind (ty-value token-value)
          (token-next stream)
        (ast-for stream ty-value token-value)))))

(defun ast-build-obj (stream)
  "Real build the object with STREAM."
  (loop
     :for (ty stmt) := (multiple-value-list (token-next stream))
     :while (and stmt (stop-when-char stmt "}"))
     :collect (when (ast-object-key-p ty)
                  (token-skip stream #\,)
                  (list (list ty stmt)
                        (ast-process-key-value stream)))))

(defun ast-build-object (stream)
  "Build the object ast with STREAM."
  `(:obj ,(remove-if #'null (ast-build-obj stream))))
