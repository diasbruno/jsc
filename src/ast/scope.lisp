(in-package :jsc-ast)

(defun ast-curly-scope (state)
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
      (progn
        (token-skip st #\})
        (ast-new st
                 (nconc (list :curly-scope)
                        (mapcar #'ast-state-tree s)))))))

(defun ast-parentesis-scope (state)
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
    (let ((s (loop
                :for expr := (ast-next-item (ast-new st nil))
                :while (and (not (eq (char-ahead st) :eof)))
                :collect (let ((ch (char-ahead st)))
                           (progn
                             (when (and (not (eq :eof ch))
                                        (char-equal ch #\,))
                               (token-skip st #\,))
                             expr)))))
      (ast-new st (nconc (list :parentesis-scope)
                         (mapcar #'ast-state-tree s))))))
