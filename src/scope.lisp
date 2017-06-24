(in-package :jsc)

(defun close-body-p (ty token)
  (and (eq ty :grp) (string= "}" token)))

(defun ast-body (stream)
  "Build the body { N..exps; } with a STREAM."
  (multiple-value-bind (ty token)
      (token-next stream)
    (progn
      (assert (string= "{" token))
      (loop
         :for (ty expr) := (multiple-value-list (token-next stream))
         :while (and expr (not (close-body-p ty expr)))
         :collect (ast-for stream ty expr)))))

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
  (multiple-value-bind (ty token)
      (token-next stream)
    (progn
      (assert (string= "(" token))
      (loop
         :for (ty arg) := (multiple-value-list (token-next stream))
         :while (stop-when-char arg ")")
         :collect (prog1 (list ty arg)
                    (token-skip stream #\,))))))
