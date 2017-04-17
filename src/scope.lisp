(in-package :jsc)

(defun close-body-p (stmt)
  (not (and (eq (car stmt) :grp)
            (string= "}" (cadr stmt)))))

(defun js-ast-body (stream)
  "Build the body { N..exps; } with a STREAM."
  (assert (string= "{" (cadr (js-token-next stream))))
  (loop
     :for stmt := (js-ast-acquire stream (js-token-next stream))
     :while (and stmt (close-body-p stmt))
     :collect stmt))

(defun js-ast-parentesis-expr (stream)
  "Build ast for expressions inside parentesis.

if '( exps ')' else if '(' exps ')'
switch '(' exps ')'
while '( exps ')'
function '( exps ')'
'( exps ')' => {}
fn.call '(' exps ')'
new T '(' exps ')'
"
  (assert (string= "(" (cadr (js-token-next stream))))
  (loop
     :for arg := (js-ast-acquire stream (js-token-next stream))
     :while (js-stop-when-char arg ")")
     :nconc (prog1 (list arg)
              (js-token-skip stream #\,))))
