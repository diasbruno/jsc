(in-package :jsc-codegen)

(defvar -jsc-code-gen-table nil)

(defmacro jsc-code-gen-table (cata)
  `(setq -jsc-code-gen-table ',cata))

(defun jsc-code-gen-exec (ls)
  (mapcan #'(lambda (x)
              (let ((dispatch (assoc (car x) -jsc-code-gen-table)))
                (if dispatch
                     (funcall (cdr dispatch) x)
                     (print "not on dispatch list"))))
          ls))

(defun id (x) x)

(defun import-to-require (expr)
  (if (eq (car expr) :import)
      (let* ((build (caadr expr))
             (required (caddr expr)))
        `(:var ((,build (:fn-call "require" ,required)))))
      expr))

(defun var-desuggar-es5 (expr)
  (if (not (eq (car expr) :var))
      `(:var ,(cdr expr))
      expr))

(defun require-property-name-es5 (expr)
  (if (eq (car expr) :obj)
      `(:obj ,(mapcar #'(lambda (x)
                          (if (eq (cadr x) :scoped-var)
                              `(,(car x) ,(car x))
                              x))
                      (cadr expr)))
      expr))

(jsc-code-gen-table ((:import . import-to-require)
                     (:export . id)
                     (:var . var-desuggar-es5)
                     (:const . var-desuggar-es5)
                     (:let . var-desuggar-es5)
                     (:obj . require-property-name-es5)
                     (:arr . id)
                     (:num . id)
                     (:str . id)))

#|
(defmacro test-expr (x)
  `(let ((expr ,x))
     (print (jsc-code-gen-exec expr))))

(test-expr '((:var (((:ident "x") (:str "a"))))
             (:let (((:ident "x") (:str "a"))))))
(test-expr '((:num "1") (:str "aaa")))
(test-expr '((:obj (((:ident "x") :scoped-var)))))
(test-expr '((:obj (((:ident "x") (:ident "x"))))
             (:obj (((:ident "x") :scoped-var)
                    ((:ident "y") :scoped-var)))))
(test-expr '((:import ((:ident "a")) (:str "test"))))
|#
(defun codegen ()
  (print "codegen"))
