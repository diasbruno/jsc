(in-package :jsc)

(defun ast-literals-p (token)
  "Check if TOKEN is literal."
  (or (eq :num (car token))
      (eq :str (car token))))

(defun ast-var-p (token)
  "Check if the TOKEN is a var-like."
  (let ((str (cadr token)))
    (or (string= "var" str)
        (string= "const" str)
        (string= "let" str))))

(defun ast-function-p (token)
  "Check if the TOKEN contains a 'function'."
  (and (string= "function" (cadr token))
       (eq (car token) :ident)))

(defun ast-obj-p (token)
  "Check if the TOKEN is open curly bracket."
  (string= "{" (cadr token)))

(defun ast-array-p (token)
  "Check if the TOKEN is open square bracket."
  (string= "[" (cadr token)))

(defun ast-object-key-p (token)
  "Check if the TOKEN has a valid key type."
  (let ((ty (car token)))
    (or (eq ty :str) (eq ty :ident))))
