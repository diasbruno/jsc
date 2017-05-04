(in-package :jsc)

(defun ast-from-file (file)
  "Build the javascript ast from a FILE."
  (with-open-file (stream file)
    (ast-from-stream stream)))

(defun ast-from-string (string)
  "Build the javascript ast from a STRING."
  (ast-from-stream (string-to-stream string)))

(defun ast-for (stream token)
  (cond
    ((ast-function-p token) (ast-build-function stream))
    ((ast-var-p token) (ast-build-var stream token))
    ((ast-obj-p token) (ast-build-object stream))
    ((ast-array-p token) (ast-build-array stream))
    ((string= "return" (cadr token))
     (progn
       `(:ret ,(ast-from-stream stream))))
    (t token)))

(defun ast-from-stream (stream)
  "Build the javascript ast from a STREAM."
  (loop
     :for token := (token-next stream)
     :while (stop-when-char token ";")
     :collect (ast-for stream token)))
