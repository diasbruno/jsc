(in-package :jsc)

(defun ast-var-name-p (ty)
  "Check if the TOKEN has a valid key type."
  (eq ty :ident))

(defun ast-var-sym (token)
  "Return the symbol for the TOKEN string."
  (cond ((string= "var" token) :var)
        ((string= "const" token) :const)
        ((string= "let" token) :let)
        (t nil)))

(defun ast-assignment (stream)
  "Build the ast for the value of a variable from a STREAM."
  (token-next stream)
  (multiple-value-bind (ty token)
      (token-next stream)
    (ast-for stream ty token)))

(defun ast-build-var (stream var-type)
  "Build the var ast for a VAR-TYPE and read from STREAM.

(const|var|let) name = value"
  `(,(ast-var-sym var-type)
     ,(loop
         :for (ty stmt) := (multiple-value-list (token-next stream))
         :while (stop-when-char stmt ";")
         :nconc (when (ast-var-name-p ty)
                  (token-skip stream #\,)
                  (list `(,(list ty stmt) ,(ast-assignment stream)))))))
