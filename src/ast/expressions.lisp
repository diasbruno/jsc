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
    (let* ((tmp (ast-new st nil))
           (in (ast-state-tree (ast-next-item tmp))))
      (setf (ast-state-tree state)
            (list (ast-state-tree state)
                  `(:aaccessor ,in))))))

(defun ast-function-call (state)
  (let* ((st (ast-state-stream state))
         (tmp (ast-new st nil))
         (s (ast-parentesis-expr tmp)))
    (print s)
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
  (let ((st (ast-state-stream state)))
    (prog1 state
      (loop
         :for c := (char-ahead st)
         :while (and (not (eq c :eof)) (should-break-expr c))
         :do (collect-connector-expr state c)))))

(defvar -jsc-op-table
  '(("=" . :assignment)
    ("+" . :addition)))

(defun find-operation (token)
  (assoc token -jsc-op-table :test #'string=))

(defun ast-binary-op (state)
  (let ((leaf (ast-next-item (ast-new (ast-state-stream state) nil))))
    (ast-join-trees state leaf)))

(defun ast-build-expression (state ty token)
  (let* ((proxy (list ty token))
         (st (ast-state-stream state)))
    (progn
      (read-spaces st)
      (setf (ast-state-tree state) proxy)
      (when (not (end-of-stream st))
        (read-spaces st)
        (if (and (string= (string (char-ahead st)) ";"))
            state
            (let* ((op-token (multiple-value-list (token-next st)))
                   (op (find-operation (cadr op-token))))
              (prog1 state

                (when op
                  (setf (ast-state-tree state)
                        (list (cdr op)
                              (ast-state-tree state)))
                  (ast-binary-op state)))))))))
