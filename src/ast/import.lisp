(in-package :jsc-ast)

(defun import-terminate (stmt)
  (or (string= stmt "from")
      (string= stmt ";")))

(defun import-glob (stream)
  (progn
    (token-next stream)
    (multiple-value-bind (ty-value token-value)
        (token-next stream)
      `(:glob ,token-value))))

(defun ast-build-import-items (stream)
  (loop
     :for (ty stmt) := (multiple-value-list (token-next stream))
     :while (and stmt (not (import-terminate stmt)))
     :collect (cond
                ((string= stmt "*") (import-glob stream))
                ((not (string= stmt ",")) (ast-for stream ty stmt nil)))))

(defun ast-build-import (stream)
  "Build the array ast with STREAM."
  (read-spaces stream)
  (let ((ch (char-ahead stream)))
    (cond
      ((eq ch #\")
       `(:import-file
         ,(multiple-value-bind (ty-value token-value)
              (token-next stream)
            (ast-for stream ty-value token-value))))
      (t
       `(:import
         ,(remove-if #'null
                     (ast-build-import-items stream))
         ,(car (ast-from-stream stream)))))))
