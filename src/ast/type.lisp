(in-package :jsc-ast)

(defstruct ast-state stream tree item)

(defmacro ast-new (a b c)
  `(make-ast-state :stream ,a :tree ,b :item ,c))

(defun ast-join-item (a b)
  (let* ((st (ast-state-stream a))
         (tr (ast-state-tree a))
         (ia (ast-state-item a))
         (ib (ast-state-item b)))
    (ast-new st tr (nconc ia `(,ib)))))

(defun ast-join-tree (st)
  (if (null (ast-state-tree st))
      (setf (ast-state-tree st)
            (ast-state-item st))
      (setf (ast-state-tree st)
            (nconc (ast-state-tree st)
                   (ast-state-item st))))
  st)

(defun ast-commit-tree (st)
  (setf (ast-state-tree st) (ast-state-item st))
  (setf (ast-state-item st) nil)
  st)

(defun ast-set-tree (st b)
  (setf (ast-state-tree st) b)
  (setf (ast-state-item st) nil)
  st)

(defun ast-set-item (st b)
  (setf (ast-state-item st) b)
  st)
