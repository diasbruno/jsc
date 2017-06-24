(in-package :jsc-tests)

(def-suite :jsc-object)
(in-suite :jsc-object)

(test ast-import
  (let ((tst (jsc:ast-from-string "import a from \"test\";")))
    (is (equal tst `((:import ((:ident "a")) (:str "test")))))))
