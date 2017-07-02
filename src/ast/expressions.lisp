(in-package :jsc-ast)

(defun should-break-expr (c)
  (and c (not (or (char-equal c #\=)
                  (char-equal c #\;)
                  (char-equal c #\,)
                  (char-equal c #\])
                  (char-equal c #\+)
                  (char-equal c #\*)
                  (char-equal c #\))
                  (char-equal c #\f)))))

(defun ast-object-accessors (stream)
  (token-skip stream #\.)
  (multiple-value-list (token-next stream)))

(defun ast-array-accessor (stream)
  (token-skip stream #\[)
  (prog1 `(:aaccessor ,(ast-next-item stream))
    (token-skip stream #\])))

(defun ast-function-call (stream)
  `(:func-call ,(ast-parentesis-expr stream)))

(defun ast-assignment (stream)
  (token-skip stream #\=)
  `(:assignment ,(ast-from-stream stream)))

(defun collect-connector-expr (stream c)
  (cond
    ((char-equal c #\.) (ast-object-accessors stream))
    ((char-equal c #\[) (ast-array-accessor stream))
    ((char-equal c #\() (ast-function-call stream))
    (t (when (and c (char-equal c #\SPACE))
         (prog1 nil
           (read-spaces stream))))))

(defun ast-expression (stream)
  (remove-if #'null
             (loop
                :for c := (peek-char nil stream nil)
                :while (should-break-expr c)
                :collect (collect-connector-expr stream c))))

(defun ast-build-expression (stream ty token)
  (let ((proxy (list ty (string token))))
    (progn
      (read-spaces stream)
      (let ((lhs `(:expr ,(cons proxy (ast-expression stream)))))
        (let ((c (peek-char nil stream nil)))
          (read-spaces stream)
          (if (and c (char-equal c #\=))
              (progn
                (token-next stream)
                `(:assignment ,lhs ,(ast-from-stream stream)))
              lhs))))))
