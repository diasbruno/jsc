(in-package :cl-user)

(asdf:defsystem jsc-tests
  :description "jsc tests."
  :author "Bruno Dias"
  :license "MIT"
  :depends-on (#:jsc
               #:fiveam)
  :components ((:module "t"
                :serial t
                :components ((:file "package")
                             (:file "types")
                             (:file "string")
                             (:file "number")
                             ;;(:file "scopes")
                             ;;(:file "object")
                             ;;(:file "array")
                             ;;(:file "var")
                             ;;(:file "function")
                             ;;(:file "import")

                             ;;(:file "expressions")
                             ))))
