(in-package :jsc)

(defun close-body-p (token)
  (not (and (eq (car token) :grp)
            (string= "}" (cadr token)))))

(defun ast-body (stream)
  "Build the body { N..exps; } with a STREAM."
  (assert (string= "{" (cadr (token-next stream))))
  (loop
     :for expr := (ast-for stream (token-next stream))
     :while (and expr (close-body-p expr))
     :collect expr))

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
  (assert (string= "(" (cadr (token-next stream))))
  (loop
     :for arg := (ast-for stream (token-next stream))
     :while (stop-when-char arg ")")
     :nconc (prog1 (list arg)
              (token-skip stream #\,))))
