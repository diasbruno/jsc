(in-package :jsc-ast)

(defun ast-from-file (file)
  "Build the javascript ast from a FILE."
  (with-open-file (stream file)
    (ast-from-stream (ast-new stream nil nil))))

(defun ast-from-string (string)
  "Build the javascript ast from a STRING."
  (let ((st (make-string-input-stream string)))
   (ast-from-stream (ast-new stream nil nil))))

(defun ast-for (state ty token &optional (allow-expr t))
  (cond
    ((ast-function-p ty token) (ast-build-function state))
    ((ast-var-p ty token) (ast-build-var state token))
    ((ast-obj-p ty token) (ast-build-object state))
    ((ast-array-p ty token) (ast-build-array state))
    ((string= "import" token) (ast-build-import state))
    ((string= "return" token) `(:ret ,(ast-from-stream state)))
    ((or (eq ty :num)
         (eq ty :ident)) (if allow-expr
                             (ast-build-expression state ty token)
                             `(,ty ,token)))
    (t `(,ty ,token)))
  state)

(defun ast-next-item (state)
  (multiple-value-bind (ty token)
      (token-next (ast-state-stream state))
    (ast-for state ty token)))

(defun ast-from-stream (state &optional (terminate ";"))
  "Build the javascript ast from a STREAM."
  (let ((st (ast-state-stream state)))
    (progn
      (loop
         :for (ty token) := (multiple-value-list (token-next st))
         :while (and token (not (string= terminate token)))
         :do (ast-for state ty token))
      (ast-join-tree state))))
