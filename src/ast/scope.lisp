(in-package :jsc-ast)

(defun ast-body (stream)
  "Build the body { N..exps; } with a STREAM.

if '( exps ')' {body} else if '(' exps ')' {body} else {body}
while '( exps ')' {body}
function '( exps ')' {body}
'( exps ')' => {body}
"
  (read-spaces stream)
  (assert (char-equal (char-ahead stream) #\{))
  (token-skip stream #\{)
  (prog1 (ast-from-stream stream "}")
    (print (format nil "after body ~a" (char-ahead stream)))
    (token-skip stream #\})))

(defun ast-parentesis-expr (stream)
  "Build ast for expressions inside parentesis.

'(' exps ')'
if '( exps ')' {body} else if '(' exps ')' {body} else {body}
switch '(' exps ')' {casebody}
while '( exps ')' {body}
function '( exps ')' {body}
'( exps ')' => {body}
fn.call '(' exps ')'
new T '(' exps ')'
"
  (read-spaces stream)
  (assert (char-equal (char-ahead stream) #\())
  (token-skip stream #\()
  (loop
     :for (ty arg) := (multiple-value-list (token-next stream))
     :while (stop-when-char arg ")")
     :collect (let ((ch (char-ahead stream)))
                (progn
                  (when (and ch (char-equal ch #\,))
                    (token-skip stream #\,))
                  (list ty arg)))))
