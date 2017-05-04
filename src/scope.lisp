(in-package :jsc)

(defun close-body-p (stmt)
  (not (and (eq (car stmt) :grp)
            (string= "}" (cadr stmt)))))

(defun ast-body (stream)
  "Build the body { N..exps; } with a STREAM."
  (assert (string= "{" (cadr (token-next stream))))
  (loop
     :for stmt := (ast-acquire stream (token-next stream))
     :while (and stmt (close-body-p stmt))
     :collect stmt))

(defun ast-parentesis-expr (stream)
  "Build ast for expressions inside parentesis.

if '( exps ')' else if '(' exps ')'
switch '(' exps ')'
while '( exps ')'
function '( exps ')'
'( exps ')' => {}
fn.call '(' exps ')'
new T '(' exps ')'
"
  (assert (string= "(" (cadr (token-next stream))))
  (loop
     :for arg := (ast-acquire stream (token-next stream))
     :while (stop-when-char arg ")")
     :nconc (prog1 (list arg)
              (token-skip stream #\,))))
