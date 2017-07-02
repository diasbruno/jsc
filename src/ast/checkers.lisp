(in-package :jsc-ast)

(defun ast-literals-p (ty token)
  "Check if TOKEN is literal."
  (or (eq :num token)
      (eq :str token)))

(defun ast-var-p (ty token)
  "Check if the TOKEN is a var-like."
  (or (string= "var" token)
      (string= "const" token)
      (string= "let" token)))

(defun ast-function-p (ty token)
  "Check if the TOKEN contains a 'function'."
  (string= "function" token))

(defun ast-obj-p (ty token)
  "Check if the TOKEN is open curly bracket."
  (string= "{" token))

(defun ast-array-p (ty token)
  "Check if the TOKEN is open square bracket."
  (string= "[" token))

(defun ast-object-key-p (ty)
  "Check if the TOKEN has a valid key type."
  (or (eq ty :str) (eq ty :ident)))
