(in-package :jsc-ast)

(defstruct ast-state stream tree)

(defmacro ast-new (a b)
  `(make-ast-state :stream ,a :tree ,b))

(defun ast-join-trees (a b)
  (let* ((st (ast-state-stream a))
         (t1 (ast-state-tree a))
         (t2 (ast-state-tree b)))
    (ast-new st (if (null t1)
                    t2
                    (nconc t1 `(,t2))))))
