(in-package :cl-user)

(defpackage #:jsc-asd
  (:use :cl :asdf))

(in-package #:jsc-asd)

(asdf:defsystem jsc
  :description "jsc."
  :version "0.1.0"
  :author "Bruno Dias <dias.h.bruno@gmail.com>"
  :license "MIT"
  :components ((:module "src/ast/"
                :serial t
                :components ((:file "package")
                             (:file "token")
                             (:file "checkers")
                             (:file "object")
                             (:file "array")
                             (:file "scope")
                             (:file "vars")
                             (:file "function")
                             (:file "import")
                             (:file "ast")))
               (:module "src/codegen/"
                :serial t
                :components ((:file "package")
                             (:file "codegen")))
               (:module "src/"
                :serial t
                :components ((:file "package")))))
