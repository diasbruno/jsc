(in-package :jsc)

(defun ast-var-name-p (token)
  "Check if the TOKEN has a valid key type."
  (eq (car token) :ident))

(defun ast-var-sym (token)
  "Return the symbol for the TOKEN string."
  (cond ((string= "var" token) :var)
        ((string= "const" token) :const)
        ((string= "let" token) :let)
        (t nil)))

(defun ast-assignment (stream)
  "Build the ast for the value of a variable from a STREAM."
  (token-next stream)
  (ast-acquire stream (token-next stream)))

(defun ast-build-var (stream var-type)
  "Build the var ast for a VAR-TYPE and read from STREAM."
  `(,(ast-var-sym (cadr var-type))
     ,(loop
         :for stmt := (token-next stream)
         :while (stop-when-char stmt ";")
         :nconc (when (ast-var-name-p stmt)
                  (token-skip stream #\,)
                  (list `(,stmt ,(ast-assignment stream)))))))
