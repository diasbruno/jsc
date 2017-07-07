(in-package :jsc-ast)

(defun ast-body (state)
  "Build the body { N..exps; } with a STREAM.

if '( exps ')' {body} else if '(' exps ')' {body} else {body}
while '( exps ')' {body}
function '( exps ')' {body}
'( exps ')' => {body}
"
  (let ((st (ast-state-stream state)))
    (read-spaces st)
    (assert (char-equal (char-ahead st) #\{))
    (token-skip st #\{)
    (let ((s (ast-from-stream state "}")))
      (print s)
      (prog1 (ast-new (ast-state-stream state)
                      (nconc (list :curly-scope) (ast-state-tree s)))
        (token-skip st #\})))))

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
                    (print ch)
                    (when (and ch (char-equal ch #\,))
                      (token-skip st #\,))
                    (list ty arg))))))
