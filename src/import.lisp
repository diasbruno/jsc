(in-package :jsc)

(defun ast-build-import-items (stream)
  (loop
     :for (ty stmt) := (multiple-value-list (token-next stream))
     :while (and stmt (not (string= stmt "from")))
     :collect (when (not (string= stmt ","))
                (ast-for stream ty stmt))))

(defun ast-build-import (stream)
  "Build the array ast with STREAM."
  (list :import
        (remove-if #'null
                   (ast-build-import-items stream))
        (car (ast-from-stream stream))))
