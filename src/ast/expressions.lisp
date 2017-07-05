(in-package :jsc-ast)

(defun should-break-expr (c)
  (and c (or (char-equal #\. c)
             (char-equal #\[ c)
             (char-equal #\( c)
             (char-equal #\SPACE c))))

(defun ast-object-accessors (state)
  (token-skip stream #\.)
  (multiple-value-list (token-next state)))

(defun ast-array-accessor (state)
  (token-skip stream #\[)
  (prog1 `(:aaccessor ,(ast-next-item state))
    (token-skip stream #\])))

(defun ast-function-call (state)
  `(:func-call ,(ast-parentesis-expr state)))

;; State -> Char -> State
(defun collect-connector-expr (state c)
  (print c)
  (cond
    ((char-equal c #\.) (ast-object-accessors state))
    ((char-equal c #\[) (ast-array-accessor state))
    ((char-equal c #\() (ast-function-call state))
    (t (when (and c (char-equal c #\SPACE))
         (prog1 nil
           (read-spaces (ast-state-stream state)))))))

;; State -> State
(defun ast-expression (state)
  (let ((st (ast-state-stream state)))
    (prog1 state
      (print state)
      (ast-set-item
       state
       (remove-if #'null
                  (loop
                     :for c := (chear-ahead st)
                     :while (should-break-expr c)
                     :collect (collect-connector-expr state c)))))))

(defvar -jsc-op-table
  '(("=" . :assignment)
    ("+" . :addition)))

(defun find-operation (token)
  (assoc token -jsc-op-table :test #'string=))

(defun ast-binary-op (state op)
  (ast-set-item state (list (cdr op)
                            (ast-state-item state)))
  (let ((leaf (ast-from-stream
               (jsc-ast:ast-new (ast-state-stream state) nil nil))))
    (ast-join-item state leaf)))

(defun ast-build-expression (state ty token)
  (let* ((proxy (list ty (string token)))
         (st (ast-state-stream state)))
    (progn
      (read-spaces st)
      (ast-join-tree state)
      (ast-set-item state proxy)
      (when (not (end-of-stream st))
        (let* ((op-token (multiple-value-list (token-next st)))
               (op (find-operation (cadr op-token))))
          (prog1 state
            (when op
              (ast-binary-op state op))))))))



