(in-package :jsc)

(defun js-ast-var-name-p (token)
  "Check if the TOKEN has a valid key type."
  (eq (car token) :ident))

(defun js-ast-var-sym (token)
  "Return the symbol for the TOKEN string."
  (cond ((string= "var" token) :var)
        ((string= "const" token) :const)
        ((string= "let" token) :let)
        (t nil)))

(defun js-ast-assignment (stream)
  "Build the ast for the value of a variable from a STREAM."
  (js-token-next stream)
  (js-ast-acquire stream (js-token-next stream)))

(defun js-ast-build-var (stream var-type)
  "Build the var ast for a VAR-TYPE and read from STREAM."
  `(,(js-ast-var-sym (cadr var-type))
     ,(loop
         :for stmt := (js-token-next stream)
         :while (js-stop-when-char stmt ";")
         :nconc (when (js-ast-var-name-p stmt)
                  (js-token-skip stream #\,)
                  (list `(,stmt ,(js-ast-assignment stream)))))))
