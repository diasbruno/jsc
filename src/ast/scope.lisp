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

(defun ast-parentesis-expr (state)
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
  (let ((st (ast-state-stream state)))
    (read-spaces st)
    (assert (char-equal (char-ahead st) #\())
    (token-skip st #\()
    (loop
       :for (ty arg) := (multiple-value-list (token-next st))
       :while (stop-when-char arg ")")
       :collect (let ((ch (char-ahead st)))
                  (progn
                    (when (and ch (char-equal ch #\,))
                      (token-skip st #\,))
                    (list ty arg))))))
