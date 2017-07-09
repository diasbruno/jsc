(in-package :jsc-ast)

(defun should-break-expr (c)
  (and c (or (char-equal #\. c)
             (char-equal #\[ c)
             (char-equal #\( c)
             (char-equal #\SPACE c))))

(defun ast-object-accessors (state)
  (let ((st (ast-state-stream state)))
    (token-skip st #\.)
    (let ((v (multiple-value-list (token-next st))))
      (setf (ast-state-tree state)
            (list (ast-state-tree state) v)))))

(defun ast-array-accessor (state)
  (let ((st (ast-state-stream state)))
    (assert (char-equal (char-ahead st) #\[))
    (token-skip st #\[)
    (let ((in (ast-state-tree (ast-next-item (ast-new st nil)))))
      (ast-new st
               (nconc (list (ast-state-tree state)
                            `(:aaccessor ,in)))))))

(defun ast-function-call (state)
  (let* ((st (ast-state-stream state))
         (tmp (ast-new st nil))
         (s (ast-parentesis-expr tmp)))
    (list :func-call s)))

;; State -> Char -> State
(defun collect-connector-expr (state c)
  (cond
    ((char-equal c #\.) (ast-object-accessors state))
    ((char-equal c #\[) (ast-array-accessor state))
    ((char-equal c #\() (ast-function-call state))
    (t (when (and c (char-equal c #\SPACE))
         (read-spaces (ast-state-stream state))))))

;; State -> State
(defun ast-expression (state)
  (let* ((st (ast-state-stream state))
         (entire-expr (loop
                         :for c := (char-ahead st)
                         :while (and (not (eq c :eof)) (should-break-expr c))
                         :collect (collect-connector-expr state c))))
    (print (format nil "collected ~a" (car entire-expr)))
    (car entire-expr)))

(defvar -jsc-op-table
  '(("=" . :assignment)
    ("+" . :addition)))

(defun find-operation (token)
  (assoc token -jsc-op-table :test #'string=))

(defun ast-binary-op (state)
  (let ((leaf (ast-next-item (ast-new (ast-state-stream state) nil))))
    (print leaf)
    (ast-join-trees state leaf)))

(defun ast-build-expression (state ty token)
  (let ((st (ast-state-stream state)))
    (progn
      (read-spaces st)
      (setf (ast-state-tree state) (list ty token))
      (let ((lhs (ast-expression state)))
        (when (not (end-of-stream st))
          (read-spaces st)
          (let ((ch (char-ahead st)))
            (progn
              (print (format nil "lhs ~a next char ~a" lhs ch))
              (if (find ch ";,)}]")
                 lhs
                 (let* ((op-token (multiple-value-list (token-next st)))
                        (op (find-operation (cadr op-token))))
                   (prog1 lhs
                     (when op
                       (setf (ast-state-tree lhs)
                             (list (cdr op)
                                   (ast-state-tree lhs)))
                       (ast-binary-op lhs))))))))))))
