(in-package :jsc-ast)

(defun import-terminate (stmt)
  (or (string= stmt "from")
      (string= stmt ";")))

(defun ast-build-import-items (stream)
  (loop
     :for (ty stmt) := (multiple-value-list (token-next stream))
     :while (and stmt (not (import-terminate stmt)))
     :collect (cond
                ((string= stmt "*")
                 (progn
                    (token-next stream)
                    (multiple-value-bind (ty-value token-value)
                        (token-next stream)
                      `(:glob ,token-value))))
                ((not (string= stmt ","))
                 (ast-for stream ty stmt)))))

(defun ast-build-import (stream)
  "Build the array ast with STREAM."
  (read-spaces stream)
  (let ((ch (peek-char nil stream nil)))
    (cond
      ((eq ch #\")
       (list :import-file
             (multiple-value-bind (ty-value token-value)
                 (token-next stream)
               (ast-for stream ty-value token-value))))
      (t (list :import
               (remove-if #'null
                          (ast-build-import-items stream))
               (car (ast-from-stream stream)))))))
