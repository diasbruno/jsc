(in-package :jsc)

(defun ast-is-scoped-p (ch)
  (and ch (or (eq ch #\,) (eq ch #\}))))

(defun ast-process-key-value (stream)
  "Get the pair of key/value from STREAM."
  (read-spaces stream)
  (token-skip stream #\:)
  (read-spaces stream)
  (let ((ch (peek-char nil stream nil)))
    (cond
      ((ast-is-scoped-p ch) (prog1 :scoped-var
                              (token-skip stream #\,)))
      (t (multiple-value-bind (ty-value token-value)
             (token-next stream)
           (ast-for stream ty-value token-value))))))

(defun ast-build-obj (stream)
  "Real build the object with STREAM."
  (loop
     :for (ty stmt) := (multiple-value-list (token-next stream))
     :while (and stmt (stop-when-char stmt "}"))
     :collect (when (ast-object-key-p ty)
                (list (list ty stmt)
                      (ast-process-key-value stream)))))

(defun ast-build-object (stream)
  "Build the object ast with STREAM.

{}
{ x }
{ x: 1 }
{ \"x\": 1 }
{ x: 1, y: 1 }
{ [CON]: 1 }
{ ...x }
"
  `(:obj ,(remove-if #'null (ast-build-obj stream))))
