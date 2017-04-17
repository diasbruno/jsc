(in-package :jsc)

(defun js-ast-from-file (file)
  "Build the javascript ast from a FILE."
  (with-open-file (stream file)
    (js-ast-from-stream stream)))

(defun js-ast-from-string (string)
  "Build the javascript ast from a STRING."
  (js-ast-from-stream (string-to-stream string)))

(defun js-ast-acquire (stream token)
  (cond
    ((js-ast-function-p token) (js-ast-build-function stream))
    ((js-ast-var-p token) (js-ast-build-var stream token))
    ((js-ast-obj-p token) (js-ast-build-object stream))
    ((js-ast-array-p token) (js-ast-build-array stream))
    ((string= "return" (cadr token))
     (progn
       `(:ret ,(js-ast-from-stream stream))))
    (t token)))

(defun js-ast-from-stream (stream)
  "Build the javascript ast from a STREAM."
  (loop
     :for token := (js-token-next stream)
     :while (js-stop-when-char token ";")
     :collect (js-ast-acquire stream token)))
