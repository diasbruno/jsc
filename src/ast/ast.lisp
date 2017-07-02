(in-package :jsc-ast)

(defun ast-from-file (file)
  "Build the javascript ast from a FILE."
  (with-open-file (stream file)
    (ast-from-stream stream)))

(defun ast-from-string (string)
  "Build the javascript ast from a STRING."
  (ast-from-stream (string-to-stream string)))

(defun ast-for (stream ty token &optional (allow-expr t))
  (cond
    ((ast-function-p ty token) (ast-build-function stream))
    ((ast-var-p ty token) (ast-build-var stream token))
    ((ast-obj-p ty token) (ast-build-object stream))
    ((ast-array-p ty token) (ast-build-array stream))
    ((string= "import" token) (ast-build-import stream))
    ((string= "return" token) `(:ret ,(ast-from-stream stream)))
    ((eq ty :ident) (if allow-expr
                        (ast-build-expression stream ty token)
                        `(,ty ,token)))
    (t `(,ty ,token))))

(defun ast-next-item (stream)
  (multiple-value-bind (ty token)
      (token-next stream)
    (ast-for stream ty token)))

(defun ast-from-stream (stream)
  "Build the javascript ast from a STREAM."
  (loop
     :for (ty token) := (multiple-value-list (token-next stream))
     :while (stop-when-char token ";")
     :collect (ast-for stream ty token)))
