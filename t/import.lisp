(in-package :jsc-tests)

(def-suite :jsc-import)
(in-suite :jsc-import)

(test ast-import
  (let ((tst (jsc:ast-from-string "import a from \"test\";")))
    (is (equal tst `((:import ((:ident "a")) (:str "test")))))))
