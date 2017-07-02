(in-package :jsc-ast)

(defun ast-body (stream)
  "Build the body { N..exps; } with a STREAM.

if '( exps ')' {body} else if '(' exps ')' {body} else {body}
while '( exps ')' {body}
function '( exps ')' {body}
'( exps ')' => {body}
"
  (read-spaces stream)
  (assert (char-equal (peek-char nil stream nil) #\{))
  (token-skip stream #\{)
  (loop
     :for (ty expr) := (multiple-value-list (token-next stream))
     :while (stop-when-char expr "}")
     :collect (ast-for stream ty expr)))

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
  (assert (char-equal (peek-char nil stream nil) #\())
  (token-skip stream #\()
  (loop
     :for (ty arg) := (multiple-value-list (token-next stream))
     :while (stop-when-char arg ")")
     :collect (let ((ch (peek-char nil stream nil)))
                (progn
                  (when (and ch (char-equal ch #\,))
                    (token-skip stream #\,))
                  (list ty arg)))))
