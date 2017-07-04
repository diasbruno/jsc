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
                     :for c := (peek-char nil st nil)
                     :while (should-break-expr c)
                     :collect (progn
                                (print c)
                                (collect-connector-expr state c))))))))

(defvar -jsc-op-table
  '(("=" . :assignment)
    ("+" . :addition)))

(defun ast-build-expression (state ty token)
  (let* ((proxy (list ty (string token)))
        (st (ast-state-stream state)))
    (prog1 state
      (read-spaces st)
      (ast-set-item state (list :expr proxy (ast-expression state))))))
