(in-package :jsc)

(defun ast-build-import (stream)
  "Build the array ast with STREAM."
  (let ((imps (loop
                 :for (ty stmt) := (multiple-value-list (token-next stream))
                 :while (and stmt (not (string= stmt "from")))
                 :collect (when (not (string= stmt ","))
                            (ast-for stream ty stmt)))))
    (list :import
          (remove-if #'null imps)
          (car (ast-from-stream stream)))))
